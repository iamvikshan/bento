// index.ts
import { Elysia } from 'elysia'
import { cors } from '@elysiajs/cors'
import { logger } from './logger'

const app = new Elysia().use(cors())

app.get('/*', async ({ request }) => {
  let someHost = 'https://bento.me'
  const url = new URL(request.url)
  const path = url.pathname + url.search

  logger.info({ path }, 'Incoming request')

  if (path === '/signup' || path === '/login') {
    logger.info({ path }, 'Redirecting auth path')
    return new Response(null, {
      status: 307,
      headers: {
        Location: `https://bento.me${path}`
      }
    })
  }

  if (path.includes('v1')) {
    someHost = 'https://api.bento.me'
    logger.debug('Using API host')
  }

  let targetUrl = someHost + path
  if (targetUrl === 'https://bento.me/') {
    targetUrl = 'https://bento.me/' + process.env.BENTO_USERNAME
  }

  // Avoid logging sensitive data from environment variables
  if (targetUrl === 'https://bento.me/' + process.env.BENTO_USERNAME) {
    logger.info('Forwarding request to bento.me/<redacted>');
  } else {
    logger.info({ targetUrl }, 'Forwarding request');
  }

  try {
    const response = await fetch(targetUrl)
    const contentType = response.headers.get('content-type') || 'text/plain'

    let results = ''
    if (contentType.includes('application/json')) {
      results = JSON.stringify(await response.json())
    } else {
      results = await response.text()
    }

    logger.info(
      {
        status: response.status,
        contentType
      },
      'Request completed'
    )

    return new Response(results, {
      headers: {
        'content-type': contentType
      }
    })
  } catch (error) {
    logger.error({ error }, 'Request failed')
    throw error
  }
})

const port = process.env.PORT || 3000
logger.info({ port }, '🦊 Server started')

export default app
