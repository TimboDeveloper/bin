#include <curl/curl.h>
#include <stdlib.h>

#include "headers/request.h"

void request(char* url) {
    CURL *curl = curl_easy_init();
    if (curl) {
        CURLcode status;
        curl_easy_setopt(curl, CURLOPT_URL, "https://example.com");
        status = curl_easy_perform(curl);
        curl_easy_cleanup(curl);
    }
}