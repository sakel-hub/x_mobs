/**
 * Deploy code to ContentDB
 * Copyright (C) 2026 SaKeL
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

import fetch from 'node-fetch'
import yargs from 'yargs/yargs'
import { hideBin } from 'yargs/helpers'
import 'dotenv/config'

const argv = yargs(hideBin(process.argv)).argv

try {
    const token = process.env.CONTENT_DB_X_MOBS_TOKEN || process.env.CONTENT_DB_TOKEN || argv.token
    if (!token) {
        console.error('Error: Missing ContentDB token! Provide CONTENT_DB_X_MOBS_TOKEN or pass --token=<token>.')
        process.exit(1)
    }

    const title = argv.title ?? argv.tag
    if (!title) {
        console.error('Error: Missing release title/tag! Pass --title=<title>.')
        process.exit(1)
    }

    const ref = argv.ref ?? title ?? 'main'

    const body = {
        method: 'git',
        title: title,
        ref: ref
    }

    console.log('Submitting release to ContentDB for SaKeL/x_mobs:', body)

    const response = await fetch('https://content.luanti.org/api/packages/SaKeL/x_mobs/releases/new/', {
        method: 'POST',
        body: JSON.stringify(body),
        headers: {
            'Content-Type': 'application/json',
            Authorization: `Bearer ${token}`
        }
    })

    const data = await response.json()
    console.log('ContentDB API response:', data)

    if (!response.ok || (data.success !== undefined && !data.success)) {
        console.error('ContentDB deployment failed:', data)
        process.exit(1)
    }

    console.log(`Successfully deployed ${title} to ContentDB!`)
} catch (error) {
    console.error('Deployment error:', error)
    process.exit(1)
}
