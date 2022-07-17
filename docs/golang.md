sqlxのIn句 && where句のやつ

```
func NamedInSql(db sqlx.DB, query string, arg interface{}) (string, []interface{}, error) {
    query, args, err := sqlx.Named(query, arg)
    if err != nil {
        return "", nil, err
    }

    query, args, err = sqlx.In(query, args...)
    if err != nil {
        return "", nil, err
    }
    query = db.Rebind(query)
 
    return query, args, err
}
```
