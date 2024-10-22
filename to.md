# Transaction Origination Runbook

## How To Run The Transaction Origination Process
1. Craft a kickstart link by collecting your DIG private key and your fmp api key
    1. Your DIG private key was provided to you via email titled "DIG TO Private Key"
    1. Your FMP API key can be accessed from the fmp dashboard: https://site.financialmodelingprep.com/developer/docs/dashboard
    1. See email for crafting kickoff link 
1. Kickstart the workflow by navigating to the fully constructed kickstart link in your browser
    1. Your browser will immediately give you a response that looks like this
    ```
    {
    "id": "1234567890abcdef",
        "statusQueryGetUri": "https://dig.azurewebsites.net/runtime/webhooks/durabletask/instances/1234567890abcdef/status",
        "sendEventPostUri": "https://dig.azurewebsites.net/runtime/webhooks/durabletask/instances/1234567890abcdef/raiseEvent/{eventName}",
        "terminatePostUri": "https://dig.azurewebsites.net/runtime/webhooks/durabletask/instances/1234567890abcdef/terminate?reason={text}",
        "rewindPostUri": "https://dig.azurewebsites.net/runtime/webhooks/durabletask/instances/1234567890abcdef/rewind?reason={text}",
        "purgeHistoryDeleteUri": "https://dig.azurewebsites.net/runtime/webhooks/durabletask/instances/1234567890abcdef/purge",
        "restartPostUri": "https://dig.azurewebsites.net/runtime/webhooks/durabletask/instances/1234567890abcdef/restart",
        "suspendPostUri": "https://dig.azurewebsites.net/runtime/webhooks/durabletask/instances/1234567890abcdef/suspend?reason={text}",
        "resumePostUri": "https://dig.azurewebsites.net/runtime/webhooks/durabletask/instances/1234567890abcdef/resume?reason={text}"
    }
    ```
    1. You can use the link in the `statusQueryGetUri` field to check the status of the transaction origination process. When navigating to that link, you'll see something like this:
    ```
    {
        "name": "orchestrate_transaction_origination_run",
        "instanceId": "c4c2d0b11a8340708eeea3beb8f740f6",
        "runtimeStatus": "Completed",
        "input": "{\"__class__\": \"TOParams\", \"__module__\": \"transaction_origination.to_utils\", \"__data__\": \"{\\\"fmp_api_key\\\": \\\"11IPLjDMjcPqfm2EI03ylIA2U5NVhlpV\\\", \\\"std_dev_cutoff_for_stock_price\\\": null, \\\"original_execution_timestamp\\\": \\\"2024-10-22T12:08:01.708699\\\"}\"}",
        "customStatus": null,
        "output": "{\"bad_performers_url\": \"https://blobs.blob.core.windows.net/transaction-origination/bad_performers-20241022123137.csv?se=2024-10-22T22%3A31%3A39Z&sp=r&sv=2024-11-04&sr=b&sig=J4tw00DNZI/cDy0nPAKPRny5IWZGkVJ/5DNbYwzrOjk%3D\", \"missed_forecasts_url\": \"https://blobs.blob.core.windows.net/transaction-origination/missed_forecasts-20241022123137.csv?se=2024-10-22T22%3A31%3A39Z&sp=r&sv=2024-11-04&sr=b&sig=UvG0vOnJa5wAfryLW9ybzyXGKbCZ4/eRDgvdn9p9Fr0%3D\", \"poorly_integrated_url\": \"https://blobs.blob.core.windows.net/transaction-origination/poorly_integrated-20241022123137.csv?se=2024-10-22T22%3A31%3A39Z&sp=r&sv=2024-11-04&sr=b&sig=g7qidkqsgXcu5xHaiyydSgryMfSJ9AeoF91iVvlNA2k%3D\"}",
        "createdTime": "2024-10-22T12:08:01Z",
        "lastUpdatedTime": "2024-10-22T12:31:39Z"
    }

    1. In the output field, you'll find the links to the csv files that contain the bad performers, missed forecasts, and poorly integrated companies. You can download these files by navigating to the links in your browser.
    1. In the future, if we add more playbooks, you'll find those links in the output field as well.

## Gotchas
1. If the runtimeStatus shows "Failed" or "Error", please copy the whole response and send it to the DIG team for further investigation. Notably, the timestamps will help us identify the issue.
1. If you need to find the keys, remember that the DIG key is in your email, and the fmp api key is in the fmp dashboard (see above for links).
1. If you can't download the csv files, make sure you're connected to the DIG VPN. This will be the application named "Harmony SASE" on your computer. The VPN may have trouble connecting from A&M offices outside of NYC and Boston, so you may need to use a different network.
1. The key code for your Harmony SASE is in your phone's Google Authenticator app. 
