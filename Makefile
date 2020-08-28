.DEFAULT_GOAL := help

APP_DIR := todo

NGINX_LOG := /var/log/nginx/access.log
MYSQL_SLOW_LOG := /var/log/mysql/slow.log

MYSQL_CONFIG := /etc/mysql/my.cnf
NGINX_CONFIG := /etc/nging/nginx.conf

DB_HOST := 127.0.0.1
DB_PORT := 3306
DB_USER := todo
DB_PASS := todo
DB_NAME := todo

EDIT_MYSQL_CONFIG := $(APP_DIR)/my.cnf
EDIT_NGINX_CONFIG := $(APP_DIR)/ngin.conf

.PHONY: help
help: ## show help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' ${MAKEFILE_LIST} | sort | awk 'BEGIN {FS = ":.*?## "}; { \
		printf "\033[36m%-20s\033[0m %s\n", $$1, $$2 \
	}'

.PHONY: setting
setting: mysql_setting nginx_setting ## mysqlとnginxの設定を反映する

.PHONY: mysql_setting
mysql_setting: ## mysqlの設定を反映する
	sudo cp $(EDIT_MYSQL_CONFIG) $(MYSQL_CONFIG)
	sudo systemctl restart mysql.service

.PHONY: nginx_setting
nginx_setting: ## nginxの設定を反映する
	sudo cp $(EDIT_NGINX_CONFIG) $(NGINX_CONFIG)
	sudo systemctl restart nginx.service

.PHONY: log_reset
log_reset: ## logファイルを初期化する
	sudo cp /dev/null $(MYSQL_SLOW_LOG)
	sudo cp /dev/null $(NGINX_LOG)

.PHONY: alp
alp: ## alpのログを見る
	alp -f $(NGINX_LOG) --aggregates "" --excludes "" --avg

.PHONY: slow
slow: ## スロークエリを見る
	pt-query-digest $(MYSQL_SLOW_LOG)

.PHONY: mysql
mysql: ## mysql接続コマンド
	mysql -h $(DB_HOST) -u $(DB_USER) -p$(DB_PASS) $(DB_NAME)

.PHONY: bench
bench: log_reset application_build ## bench回す前に実行するコマンド

.PHONY: application_build
application_build: ## application build
	cd $(APP_DIR); go build -o isucari
	sudo systemctl restart isucari.golang.service

.PHONY: setup
setup: install_alp install_pt_query_digest install_discordcat check ## 使うtoolをインストールする

.PHONY: install_alp
install_alp:
	@echo 'Install alp'
	@wget https://github.com/tkuchiki/alp/releases/download/v1.0.3/alp_linux_amd64.zip
	@unzip alp_linux_amd64.zip
	@sudo mv alp /usr/local/bin/alp

.PHONY: install_pt_query_digest
install_pt_query_digest:
	@echo 'Install pt-query-digest'
	@wget https://github.com/percona/percona-toolkit/archive/3.0.5-test.tar.gz
	@tar zxvf 3.0.5-test.tar.gz
	@sudo mv ./percona-toolkit-3.0.5-test/bin/pt-query-digest /usr/local/bin/pt-query-digest

.PHONY: install_discordcat
install_discordcat:
	@wget https://github.com/k-nasa/discordcat/releases/download/0.1.0/discordcat_x86_64-unknown-linux-gnu.tar.gz
	@tar -xf discordcat_x86_64-unknown-linux-gnu.tar.gz
	@sudo mv ./discordcat_x86_64-unknown-linux-gnu/discordcat /usr/local/bin/
	@sudo chmod +x /usr/local/bin/discordcat

.PHONY: check
check:
	@chmod +x ./check.sh && ./check.sh
