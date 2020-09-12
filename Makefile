.DEFAULT_GOAL := help

APP_DIR := todo

NGINX_LOG := /var/log/nginx/access.log
MYSQL_SLOW_LOG := /var/log/mysql/slow.log

MYSQL_CONFIG := /etc/mysql/my.cnf
NGINX_CONFIG := /etc/nginx/nginx.conf

DB_HOST := 127.0.0.1
DB_PORT := 3306
DB_USER := todo
DB_PASS := todo
DB_NAME := todo

EDIT_MYSQL_CONFIG := $(APP_DIR)/my.cnf
EDIT_NGINX_CONFIG := $(APP_DIR)/nginx.conf

.PHONY: help
help: ## show help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' ${MAKEFILE_LIST} | sort | awk 'BEGIN {FS = ":.*?## "}; { \
		printf "\033[36m%-20s\033[0m %s\n", $$1, $$2 \
	}'

.PHONY: log_reset
log_reset: ## logファイルを初期化する
	@sudo cp /dev/null $(MYSQL_SLOW_LOG)
	@sudo cp /dev/null $(NGINX_LOG)

.PHONY: alp
alp: ## alpのログを見る
	@sudo cat $(NGINX_LOG) | alp ltsv --sort avg -r --format md -m "" --filters ""

.PHONY: slow
slow: ## スロークエリを見る
	@sudo pt-query-digest $(MYSQL_SLOW_LOG)

.PHONY: slow_on
slow_on: ## mysqlのslowログをonにする
	@sudo mysql -e "set global slow_query_log_file = '$(MYSQL_SLOW_LOG)'; set global long_query_time = 0; set global slow_query_log = ON;"

.PHONY: slow_off
slow_off: ## mysqlのslowログをoffにする
	@sudo mysql -e "set global slow_query_log = OFF;"

.PHONY: show_slow_config
show_slow_config: ## mysqlのslowログ設定を確認するコマンド
	@sudo mysql -e "show variables like 'slow_query%'"

.PHONY: send_result
send_result: ## discordにalpとslowの出力を送信する
	@make alp  > tmp.txt && discordcat -f tmp.txt --filename alp.md
	@make slow > tmp.txt && discordcat -f tmp.txt --filename slow_log.txt

.PHONY: mysql
mysql: ## mysql接続コマンド
	mysql -h $(DB_HOST) -u $(DB_USER) -p$(DB_PASS) $(DB_NAME)

pprof:
	@go tool pprof -png -output pprof.png http://localhost:6060/debug/pprof/profile && discordcat -f pprof.png --filename pprof.png

.PHONY: application_build
application_build: ## application build (wip)
	@echo "Please implement!!"

.PHONY: application_restart
application_restart: ## application restart (wip)
	@echo "Please implement!!"

.PHONY: middleware_restart
middleware_restart: ## mysqlとnginxのrestart
	sudo systemctl restart mysql
	sudo systemctl restart nginx

.PHONY: restart
restart: application_restart middleware_restart ## application, mysql, nginxのリスタート

.PHONY: bench
bench: slow_on log_reset application_build restart ## bench回す前に実行するコマンド(これで全ての前処理が完了する状態を作る)
