#!/usr/bin/env bash
APP_DIR="${HOME}/Downloads/Applications"

mkdir -p ${APP_DIR}

# # VSCODE
wget 'https://az764295.vo.msecnd.net/stable/b380da4ef1ee00e224a15c1d4d9793e27c2b6302/VSCode-darwin-arm64.zip' \
  -H 'authority: az764295.vo.msecnd.net' \
  -H 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7' \
  -H 'accept-language: en-US,en;q=0.9' \
  -H 'dnt: 1' \
  -H 'referer: https://code.visualstudio.com/' \
  -H 'sec-ch-ua: "Not.A/Brand";v="8", "Chromium";v="114"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'sec-ch-ua-platform: "macOS"' \
  -H 'sec-fetch-dest: document' \
  -H 'sec-fetch-mode: navigate' \
  -H 'sec-fetch-site: cross-site' \
  -H 'upgrade-insecure-requests: 1' \
  -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36' \
  -P "${APP_DIR}" 

# SPOTIFY
wget 'https://download.scdn.co/SpotifyInstaller.zip' \
  -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7' \
  -H 'Accept-Language: en-US,en;q=0.9' \
  -H 'Connection: keep-alive' \
  -H 'DNT: 1' \
  -H 'Referer: https://www.spotify.com/' \
  -H 'Sec-Fetch-Dest: document' \
  -H 'Sec-Fetch-Mode: navigate' \
  -H 'Sec-Fetch-Site: cross-site' \
  -H 'Sec-Fetch-User: ?1' \
  -H 'Upgrade-Insecure-Requests: 1' \
  -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36' \
  -H 'sec-ch-ua: "Not.A/Brand";v="8", "Chromium";v="114"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'sec-ch-ua-platform: "macOS"' \
  -P "${APP_DIR}" 

# ARC
wget 'https://arc.net/release/Arc-latest.dmg' \
  -H 'DNT: 1' \
  -H 'Upgrade-Insecure-Requests: 1' \
  -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36' \
  -H 'sec-ch-ua: "Not.A/Brand";v="8", "Chromium";v="114"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'sec-ch-ua-platform: "macOS"' \
  -P "${APP_DIR}" 

# SPARK
wget 'https://downloads.sparkmailapp.com/Spark3/mac/dist/3.5.2.49597/Spark.dmg' \
  -H 'authority: downloads.sparkmailapp.com' \
  -H 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7' \
  -H 'accept-language: en-US,en;q=0.9' \
  -H 'cookie: spark_conv_r=utm_medium%3Aorganic%2Autm_source%3Agoogle.com%2Autm_initial_source%3Agoogle.com%2Autm_initial_medium%3Aorganic%2Autm_initial_campaign%3A; _gid=GA1.2.49430895.1686454550; _gat=1; cebs=1; _gcl_au=1.1.1824293004.1686454550; _ce.clock_event=1; _ce.clock_data=47%2C157.131.198.127%2C1%2C5f0ff5d8799ed4c0ed355fa474a7bbc2; cebsp_=1; _ce.s=v~b3629ec5dcbd633e82e044dc410aba4f4731e425~lcw~1686454551466~vpv~0~v11.rlc~1686454550552~ir~1~gtrk.la~liqvi150~lcw~1686454558020; spark_amplitude_id_90b9f99de09deb9b4818d99f457739f4sparkmailapp.com=eyJkZXZpY2VJZCI6Ijc2YjBkYmY5LThkY2ItNDkzYi04MDYyLTBhZWE2OWNkYWIwMy0xNjg2NDU0NTQ5MDE2UiIsInVzZXJJZCI6bnVsbCwib3B0T3V0IjpmYWxzZSwic2Vzc2lvbklkIjoxNjg2NDU0NTQ5MDE2LCJsYXN0RXZlbnRUaW1lIjoxNjg2NDU0NTU4NzY2LCJldmVudElkIjoxLCJpZGVudGlmeUlkIjoyLCJzZXF1ZW5jZU51bWJlciI6M30=; _ga=GA1.1.516226387.1686454550; _ga_GVWG0NPESG=GS1.1.1686454550.1.1.1686454558.0.0.0' \
  -H 'dnt: 1' \
  -H 'referer: https://sparkmailapp.com/' \
  -H 'sec-ch-ua: "Not.A/Brand";v="8", "Chromium";v="114"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'sec-ch-ua-platform: "macOS"' \
  -H 'sec-fetch-dest: document' \
  -H 'sec-fetch-mode: navigate' \
  -H 'sec-fetch-site: same-site' \
  -H 'sec-fetch-user: ?1' \
  -H 'upgrade-insecure-requests: 1' \
  -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36' \
  -P "${APP_DIR}" 

# Raycast
wget 'https://u15802931.ct.sendgrid.net/ls/click?upn=6jEkpzZJ1YxiRMEOH3-2FVmVWsnYC0pL9UHwky5uZfr6qvelDJvEu7HwWwEygPNeQvHXjW_8DvO0oRfE93HwyucNGbr4LP6tNyhdLX8JW5q6YbiEWb9ghAGMuK08vTEWLe9UhT4w9LXZzcGscm-2BNonNw-2FhHGbECoz-2FaMCwER616tSN8JspDkqlj4M29XpLb4rl8R4rq5O7WHlQEXCSxhyY4-2BEFG5XvS5C9mKHwMoVB-2FJJ7SM-2F4tSpqpWVQOVwj-2F77vixxis3aFaHUQ4mrBC5hcvzwvQg2TbK2ev9m9wyKm33J-2BznxZr4Dhb6-2BY-2BcJec3rk1w2XjBBgmeGJt0IqubacKoCIxUUMLcol2rIQDzeYZBjH709veS98RYUAtSIt6r8x-2FAi6LXag9DCN2qMDoQaI7eILWos3CJ6Tx4xqLoVsL5NmSa3MPqUUtsl0IsRO3blOX6mS-2FjXh8EbUm4Tqe0-2Bp7LEpXgHOJHyGkw6viLAFOVXHBu7H8CYrmBprZIJw-2Bu-2FZLj7KA2xRelsbgBl4I8n9wVy7B4LEbg3O8lw-2BwrDtkx7Gml9Ag5RFFzGlDqvXSp3YMIgLOLpRRj7DWj-2FU-2BqQICzQnFTvTSKp-2F0EXrf9AKTngOiE6GUUmzSHGr2yPU3bBMIjpMVKrBnCKs99nTCcZCm-2FVXL208sm-2B1RbczwwQkQ3kRpIgu4liDnGzLldjFxMBl9tfivuwRh6CtvBSlOLJ8EMX-2Fqw-2FUGgtMZp4Va8kYmkJFCSj-2BVTe5-2B8fFy-2FwqRzUXnFRLPWyoRZCNi-2BveOjoM9FUNpV0WWPxsFGbyvQuxumSBaeEOpVdq7CWKg86-2Fx79YVJe7Yw7peB13zJE-2FUdssRu7qOlGxR9etr65Z0npNhkRsbYNAlpdNhx0Hy4EyDBUQ0a9elGB6EGNJ1GGFlVWPBVHe2rfwaDzgp7bTcHhhT4OXOgXtOD9W4h-2FuL3HTzBiK69hZnnBbIH0F7mI9C4yNVxf2Ci7QOfSEADS4XIolWtLD6c-2BC-2FA5YRTi5iSoAH6YMLq3zIpaILBLqugWeV5GpfROtCZUTWPBvNxoZqXO1BSpVJAi4XNreeUw-2FSfnC3sgvJTeGIGOnUCpcKyegtPryPBRnjCS18yAbi47cHSNUKHdUPKr5kpIRhpP8nkbkQli-2Ftn-2F0P'  -H 'authority: downloads.sparkmailapp.com' \
  -H 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7' \
  -H 'accept-language: en-US,en;q=0.9' \
  -H 'cookie: spark_conv_r=utm_medium%3Aorganic%2Autm_source%3Agoogle.com%2Autm_initial_source%3Agoogle.com%2Autm_initial_medium%3Aorganic%2Autm_initial_campaign%3A; _gid=GA1.2.49430895.1686454550; _gat=1; cebs=1; _gcl_au=1.1.1824293004.1686454550; _ce.clock_event=1; _ce.clock_data=47%2C157.131.198.127%2C1%2C5f0ff5d8799ed4c0ed355fa474a7bbc2; cebsp_=1; _ce.s=v~b3629ec5dcbd633e82e044dc410aba4f4731e425~lcw~1686454551466~vpv~0~v11.rlc~1686454550552~ir~1~gtrk.la~liqvi150~lcw~1686454558020; spark_amplitude_id_90b9f99de09deb9b4818d99f457739f4sparkmailapp.com=eyJkZXZpY2VJZCI6Ijc2YjBkYmY5LThkY2ItNDkzYi04MDYyLTBhZWE2OWNkYWIwMy0xNjg2NDU0NTQ5MDE2UiIsInVzZXJJZCI6bnVsbCwib3B0T3V0IjpmYWxzZSwic2Vzc2lvbklkIjoxNjg2NDU0NTQ5MDE2LCJsYXN0RXZlbnRUaW1lIjoxNjg2NDU0NTU4NzY2LCJldmVudElkIjoxLCJpZGVudGlmeUlkIjoyLCJzZXF1ZW5jZU51bWJlciI6M30=; _ga=GA1.1.516226387.1686454550; _ga_GVWG0NPESG=GS1.1.1686454550.1.1.1686454558.0.0.0' \
  -H 'dnt: 1' \
  -H 'referer: https://sparkmailapp.com/' \
  -H 'sec-ch-ua: "Not.A/Brand";v="8", "Chromium";v="114"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'sec-ch-ua-platform: "macOS"' \
  -H 'sec-fetch-dest: document' \
  -H 'sec-fetch-mode: navigate' \
  -H 'sec-fetch-site: same-site' \
  -H 'sec-fetch-user: ?1' \
  -H 'upgrade-insecure-requests: 1' \
  -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36' \
  -O "${APP_DIR}/Raycast.dmg" 

wget 'https://cdn.flexibits.com/Fantastical_3.7.14.zip' \
  -H 'authority: cdn.flexibits.com' \
  -H 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7' \
  -H 'accept-language: en-US,en;q=0.9' \
  -H 'cookie: _pk_ref.1.229e=%5B%22%22%2C%22%22%2C1686455004%2C%22https%3A%2F%2Fwww.google.com%2F%22%5D; _pk_id.1.229e=6ec2d560e9bdc1f3.1686455004.; _pk_ses.1.229e=1' \
  -H 'dnt: 1' \
  -H 'referer: https://flexibits.com/' \
  -H 'sec-ch-ua: "Not.A/Brand";v="8", "Chromium";v="114"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'sec-ch-ua-platform: "macOS"' \
  -H 'sec-fetch-dest: document' \
  -H 'sec-fetch-mode: navigate' \
  -H 'sec-fetch-site: same-site' \
  -H 'sec-fetch-user: ?1' \
  -H 'upgrade-insecure-requests: 1' \
  -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36' \
  -P "${APP_DIR}" 

wget 'https://downloads.1password.com/mac/1Password.zip' \
  -H 'authority: downloads.1password.com' \
  -H 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7' \
  -H 'accept-language: en-US,en;q=0.9' \
  -H 'cookie: _d1=v; _fturl=https://1password.com/downloads/mac/?utm_source=google&utm_medium=cpc&utm_campaign=18388341772&utm_content=&utm_term=&gclid=CjwKCAjwvpCkBhB4EiwAujULMtAW4jqSbPS1h6Rj9xUbxGT5yRSP63SFjLAqnnbGw2_-_sNbsZsBYhoC5WsQAvD_BwE&gclsrc=aw.ds; _ga=GA1.2.1431933198.1686455910; _gid=GA1.2.569977866.1686455910; _gac_UA-435167-16=1.1686455910.CjwKCAjwvpCkBhB4EiwAujULMtAW4jqSbPS1h6Rj9xUbxGT5yRSP63SFjLAqnnbGw2_-_sNbsZsBYhoC5WsQAvD_BwE; _gat=1; ref=gclid=CjwKCAjwvpCkBhB4EiwAujULMtAW4jqSbPS1h6Rj9xUbxGT5yRSP63SFjLAqnnbGw2_-_sNbsZsBYhoC5WsQAvD_BwE; _cc=V; _fs=269ea680-337f-4127-b43a-4239ec384638; _gali=mac' \
  -H 'dnt: 1' \
  -H 'referer: https://1password.com/downloads/mac/?utm_source=google&utm_medium=cpc&utm_campaign=18388341772&utm_content=&utm_term=&gclid=CjwKCAjwvpCkBhB4EiwAujULMtAW4jqSbPS1h6Rj9xUbxGT5yRSP63SFjLAqnnbGw2_-_sNbsZsBYhoC5WsQAvD_BwE&gclsrc=aw.ds' \
  -H 'sec-ch-ua: "Not.A/Brand";v="8", "Chromium";v="114"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'sec-ch-ua-platform: "macOS"' \
  -H 'sec-fetch-dest: document' \
  -H 'sec-fetch-mode: navigate' \
  -H 'sec-fetch-site: same-site' \
  -H 'sec-fetch-user: ?1' \
  -H 'upgrade-insecure-requests: 1' \
  -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36' \
  -P "${APP_DIR}" 

wget 'https://cdn.zoom.us/prod/5.14.10.19202/zoomusInstallerFull.pkg' \
  -H 'authority: cdn.zoom.us' \
  -H 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7' \
  -H 'accept-language: en-US,en;q=0.9' \
  -H 'cookie: _ga=GA1.2.280239496.1686455954; _gid=GA1.2.271087769.1686455954; _gat_UA-50650355-1=1; _cs_c=0; _hjSessionUser_437270=eyJpZCI6ImFmM2E5YzUzLWY2NjQtNWM4MC04OWZhLWFiOWRhMjNjY2UyYSIsImNyZWF0ZWQiOjE2ODY0NTU5NTM5MTIsImV4aXN0aW5nIjpmYWxzZX0=; _hjFirstSeen=1; _hjIncludedInSessionSample_437270=0; _hjSession_437270=eyJpZCI6IjAzMjY3ZWRlLTY2YzYtNDhkZi04OTZiLTc3MGQ4N2FmYTM2OCIsImNyZWF0ZWQiOjE2ODY0NTU5NTM5MTYsImluU2FtcGxlIjpmYWxzZX0=; __zlcmid=1GJlt6DTlZrPgFI; OptanonAlertBoxClosed=2023-06-11T03:59:15.899Z; _gcl_au=1.1.61497082.1686455956; _cs_id=e4670bda-0602-aacf-a8aa-09b7d3eeeace.1686455953.1.1686455955.1686455953.1.1720619953749; _cs_s=2.5.0.1686457755920; _fbp=fb.1.1686455956001.1170140695; _zm_ssid=aw1_c_w8E4szYFQImQfU85_xMLHQ; _zm_ctaid=_88ZRkFMSrqdCOgqcYeXnQ.1686455960665.be26736681b214fd131dde6ec4f464a3; _zm_chtaid=625; _zm_mtk_guid=8f5498a7d8fa4c3aa0b2692e3b5fe54a; _zm_csp_script_nonce=dS3ea683SWGTy8mvtN1Xxg; _zm_currency=USD; _zm_visitor_guid=8f5498a7d8fa4c3aa0b2692e3b5fe54a; __cf_bm=UVh.aiuILYTnxv9OSUvxj.6KN7IZ09TcJhDcXzwq5qg-1686455960-0-Ae/9dJozwWgD0yaBgb4Xp55V4yXwm4olyT/uWzQCZm4bfg6tO/aEHkuInVX8UtJfUv5jqFRJpb3xNH63iPmhnxU=; _zm_page_auth=aw1_c_3IegUNmNR66L0ep9grvluw; _zm_lang=en-US; OnetrustActiveGroups=C0004C0003C0002C0001; OptanonConsent=isGpcEnabled=0&datestamp=Sat+Jun+10+2023+20%3A59%3A22+GMT-0700+(Pacific+Daylight+Time)&version=6.21.0&isIABGlobal=false&hosts=&consentId=a102417b-f5fe-4fa4-aa12-ba9d22fb92c9&interactionCount=1&landingPath=NotLandingPage&groups=C0004%3A1%2CC0003%3A1%2CC0002%3A1%2CC0001%3A1&geolocation=US%3BCA&AwaitingReconsent=false; _zm_cdn_blocked=unlog_unblk; _zm_tracking_guid=0bd9b19a27b5490a97c7fc7c817d2d87' \
  -H 'dnt: 1' \
  -H 'referer: https://zoom.us/' \
  -H 'sec-ch-ua: "Not.A/Brand";v="8", "Chromium";v="114"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'sec-ch-ua-platform: "macOS"' \
  -H 'sec-fetch-dest: document' \
  -H 'sec-fetch-mode: navigate' \
  -H 'sec-fetch-site: same-site' \
  -H 'sec-fetch-user: ?1' \
  -H 'upgrade-insecure-requests: 1' \
  -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36' \
  -O "${APP_DIR}/zoom.pkg" 

wget 'https://folivora.ai/releases/BetterTouchTool.zip' \
  -H 'authority: cdn.zoom.us' \
  -H 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7' \
  -H 'accept-language: en-US,en;q=0.9' \
  -H 'cookie: _ga=GA1.2.280239496.1686455954; _gid=GA1.2.271087769.1686455954; _gat_UA-50650355-1=1; _cs_c=0; _hjSessionUser_437270=eyJpZCI6ImFmM2E5YzUzLWY2NjQtNWM4MC04OWZhLWFiOWRhMjNjY2UyYSIsImNyZWF0ZWQiOjE2ODY0NTU5NTM5MTIsImV4aXN0aW5nIjpmYWxzZX0=; _hjFirstSeen=1; _hjIncludedInSessionSample_437270=0; _hjSession_437270=eyJpZCI6IjAzMjY3ZWRlLTY2YzYtNDhkZi04OTZiLTc3MGQ4N2FmYTM2OCIsImNyZWF0ZWQiOjE2ODY0NTU5NTM5MTYsImluU2FtcGxlIjpmYWxzZX0=; __zlcmid=1GJlt6DTlZrPgFI; OptanonAlertBoxClosed=2023-06-11T03:59:15.899Z; _gcl_au=1.1.61497082.1686455956; _cs_id=e4670bda-0602-aacf-a8aa-09b7d3eeeace.1686455953.1.1686455955.1686455953.1.1720619953749; _cs_s=2.5.0.1686457755920; _fbp=fb.1.1686455956001.1170140695; _zm_ssid=aw1_c_w8E4szYFQImQfU85_xMLHQ; _zm_ctaid=_88ZRkFMSrqdCOgqcYeXnQ.1686455960665.be26736681b214fd131dde6ec4f464a3; _zm_chtaid=625; _zm_mtk_guid=8f5498a7d8fa4c3aa0b2692e3b5fe54a; _zm_csp_script_nonce=dS3ea683SWGTy8mvtN1Xxg; _zm_currency=USD; _zm_visitor_guid=8f5498a7d8fa4c3aa0b2692e3b5fe54a; __cf_bm=UVh.aiuILYTnxv9OSUvxj.6KN7IZ09TcJhDcXzwq5qg-1686455960-0-Ae/9dJozwWgD0yaBgb4Xp55V4yXwm4olyT/uWzQCZm4bfg6tO/aEHkuInVX8UtJfUv5jqFRJpb3xNH63iPmhnxU=; _zm_page_auth=aw1_c_3IegUNmNR66L0ep9grvluw; _zm_lang=en-US; OnetrustActiveGroups=C0004C0003C0002C0001; OptanonConsent=isGpcEnabled=0&datestamp=Sat+Jun+10+2023+20%3A59%3A22+GMT-0700+(Pacific+Daylight+Time)&version=6.21.0&isIABGlobal=false&hosts=&consentId=a102417b-f5fe-4fa4-aa12-ba9d22fb92c9&interactionCount=1&landingPath=NotLandingPage&groups=C0004%3A1%2CC0003%3A1%2CC0002%3A1%2CC0001%3A1&geolocation=US%3BCA&AwaitingReconsent=false; _zm_cdn_blocked=unlog_unblk; _zm_tracking_guid=0bd9b19a27b5490a97c7fc7c817d2d87' \
  -H 'dnt: 1' \
  -H 'referer: https://zoom.us/' \
  -H 'sec-ch-ua: "Not.A/Brand";v="8", "Chromium";v="114"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'sec-ch-ua-platform: "macOS"' \
  -H 'sec-fetch-dest: document' \
  -H 'sec-fetch-mode: navigate' \
  -H 'sec-fetch-site: same-site' \
  -H 'sec-fetch-user: ?1' \
  -H 'upgrade-insecure-requests: 1' \
  -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36' \
  -P "${APP_DIR}" 

## Unzip the zip files
pushd "${APP_DIR}" > /dev/null

# Check if there are any zip files in the directory
if ls *.zip 1> /dev/null 2>&1; then
    # Iterate over each .zip file in the directory
    for zip in *.zip
    do
        # Unzip the file
        unzip -q "$zip"

        # Check if unzip was successful
        if [ $? -eq 0 ]; then
            echo "$zip unzipped successfully"
            # If it was, remove the zip file
            rm "$zip"
        else
            echo "Failed to unzip $zip"
        fi
    done
else
    echo "No zip files found in the directory"
fi

# Return to the original directory
popd > /dev/null
