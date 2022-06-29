"""
TODO: Add docstring
"""
function empty_database!(; db_name = "StenoTracker.db")
    db = SQLite.DB(db_name)

    choice = prompt(
        "This is a PERMANENT action and will completely delete all entries in your database. Are you sure you want to proceed? (Y/N)",
    )

    if choice == lowercase("Y")
        DBInterface.execute(db, """DELETE FROM practice;""")
        println("Database has been emptied!")
    else
        println("Database has NOT been emptied!")
    end

end

"""
TODO: Add docstring
"""
function dump_database(; db_name = "StenoTracker.db")
    db = SQLite.DB(db_name)

    DBInterface.execute(db, """
    SELECT * FROM practice;
    """)


end

"""
TODO: Add docstring
"""
function create_database!(; db_path = "StenoTracker.db")

    if !isfile(db_path)
        touch(db_path)
        DBInterface.execute(
            db_path,
            """
            CREATE TABLE practice (
            PRACTICE_DATE DATE NOT NULL,
            WPM FLOAT NOT NULL,
            ACC FLOAT);
            """,
        )
        println("Database created at $(db_path)")
    end

    if isfile(db_path)
        delete_db = prompt(
            "The database already exists! Would you like to recreate it? THIS WILL DELETE THE OLD DATABASE! Enter Y for Yes and N for No",
        )
        if lowercase(delete_db) == "y"
            rm(db_path)
            touch(db_path)
            DBInterface.execute(
                db_path,
                """
                CREATE TABLE practice (
                PRACTICE_DATE DATE NOT NULL,
                WPM FLOAT NOT NULL,
                ACC FLOAT);
                """,
            )
        end

    end

    return db_path

end

export create_database, dump_database, empty_database
