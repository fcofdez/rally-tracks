from elasticsearch.client.utils import _make_path
import asyncio


def persistent_search(es, params):
    es.transport.perform_request("POST", "/_persistent_search", body=params.get("body", "{}"))


async def persistent_search_async(es, params):
    index = params.get("index")
    poll_interval = params.get("poll_interval", 0.001)
    response = await es.transport.perform_request("POST", "/_persistent_search/", body=params.get("body", "{}"))
    while True:
        try:
            response = await es.transport.perform_request("GET", _make_path("_persistent_search", response["id"]))
            return
        except Exception as e:
            await asyncio.sleep(poll_interval)


def register(registry):
    async_runner = registry.meta_data.get("async_runner", False)
    if async_runner:
        registry.register_runner("persistent-search", persistent_search_async, async_runner=True)
    else:
        registry.register_runner("persistent-search", persistent_search)
