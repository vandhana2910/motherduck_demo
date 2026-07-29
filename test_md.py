import duckdb
con = duckdb.connect()
con.execute("ATTACH 'md:dbt_demo'")  # will prompt browser login if no token set