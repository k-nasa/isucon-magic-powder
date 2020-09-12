## Mysqlについてのメモ

よく使うコマンドを一応メモっておく

### table一覧

```
show tables
```

### データ量


```sql
SELECT table_name, engine, table_rows, avg_row_length, floor((data_length+index_length)/1024/1024) as allMB, floor((data_length)/1024/1024) as dMB, floor((index_length)/1024/1024) as iMB FROM information_schema.tables WHERE table_schema=database() ORDER BY (data_length+index_length) DESC;
```

### index

複合キーはカンマ区切りでカラム名を書けばいい。

追加
```sql
alter table <table> add index <index name> (<column>, <column>);
```

削除
```
alter table <table> drop index <index name>
```

`create index`や`drop index`でも追加削除はできるけど`alter table`でできるのでそっちでやっちゃう。

確認

```
show index from <table name>
```

### schema

```
desc <table name>
```

### slowログ

こんな感じで設定できる。 mysqlを再起動すると設定は消えちゃうので常に反映させたいならconfigファイルに書き込むべし。
```
sudo mysql -e "set global slow_query_log_file = '$(MYSQL_SLOW_LOG)'; set global long_query_time = 0; set global slow_query_log = ON;"
```

```my.cnf
[mysqld]
slow_query_log = 1
slow_query_log_file = /var/log/mysql/slow.log
long_query_time = 0
```

ちゃんと設定できてるか確認

```
sudo mysql -e "show variables like 'slow_query%'"
```