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

```

log_format json '{'
  '"time": "$time_local",'
  '"remote_addr": "$remote_addr",'
  '"host": "$host",'
  '"remote_user": "$remote_user",'
  '"status": "$status",'
  '"server_protocol": "$server_protocol",'
  '"request_method": "$request_method",'
  '"request_uri": "$request_uri",'
  '"request": "$request",'
  '"body_bytes_sent": "$body_bytes_sent",'
  '"request_time": "$request_time",'
  '"upstream_response_time": "$upstream_response_time",'
  '"http_referer": "$http_referer", '
  '"http_user_agent": "$http_user_agent",'
  '"http_x_forwarded_for": "$http_x_forwarded_for",'
  '"http_x_forwarded_proto": "$http_x_forwarded_proto"'
'}';

access_log /var/log/nginx/access.log json;
```
