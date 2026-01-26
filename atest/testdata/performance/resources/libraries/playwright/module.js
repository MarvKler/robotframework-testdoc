async function injectRequestApiIntoPage(page) {
    return page.exposeFunction('_request', async function ({url, method, options}) {
        const response = await page.request[method.toLowerCase()](url, options)
        const data = {status: response.status(), body: await response.text(), headers: response.headers()}
        response.dispose()

        return data
    })
}

exports.__esModule = true
exports.injectRequestApiIntoPage = injectRequestApiIntoPage