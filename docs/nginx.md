## log format

ltsv

```
log_format ltsv "time:$time_local"
                "\thost:$remote_addr"
                "\tforwardedfor:$http_x_forwarded_for"
                "\treq:$request"
                "\tstatus:$status"
                "\tmethod:$request_method"
                "\turi:$request_uri"
                "\tsize:$body_bytes_sent"
                "\treferer:$http_referer"
                "\tua:$http_user_agent"
                "\treqtime:$request_time"
                "\tcache:$upstream_http_x_cache"
                "\truntime:$upstream_http_x_runtime"
                "\tapptime:$upstream_response_time"
                "\tvhost:$host";

access_log /var/log/nginx/access.log ltsv;
```


json

```nginx.conf
log_format json escape=json '{"time":"$time_local",'
  '"host":"$remote_addr",'
    '"forwardedfor":"$http_x_forwarded_for",'
    '"req":"$request",'
    '"status":"$status",'
    '"method":"$request_method",'
    '"uri":"$request_uri",'
    '"body_bytes":$body_bytes_sent,'
    '"referer":"$http_referer",'
    '"ua":"$http_user_agent",'
    '"request_time":$request_time,'
    '"cache":"$upstream_http_x_cache",'
    '"runtime":"$upstream_http_x_runtime",'
    '"response_time":"$upstream_response_time",'
    '"vhost":"$host"}';

access_log /var/log/nginx/access.log json;
```
