
#ifndef REQUEST_H
#define REQUEST_H
#define curl_init curl_easy_init

typedef unsigned short int cstatus_t;
typedef struct http_response {
    cstatus_t status_code;
} Response;
#endif

void request(char* url);