import mysql.connector
from robot.api.deco import keyword
import json
import os


class bdd:
    def __init__(self, name:str = "urbex", mdp: str = "@UrbexPAS1", host:str = "localhost", database:str = "Urbex") -> None:
        self._host:str = host
        self._user:str = name
        self._mdp:str = mdp
        self.database:str = database
        self.conn = mysql.connector.connect(host=host, user=name, password=mdp, database=database)
        self.cursor = self.conn.cursor()

        # Private values

        self._user_insert = ['pseudo', 'grade', 'admin', 'mdp']

    #####################################################
    #                                                   #
    #               Database commands                   #
    #                                                   #
    #####################################################

    def open_connection(self):
        """Open a connection to MySql"""
        self.conn = mysql.connector.connect(host=self._host, user=self._user, pasword=self._mdp, database=self.database)
        return self

    def test_connection(self) -> bool:
        """Test if the conncetion is set"""
        if self.conn.is_connected():
            return True
        print("No connection to MySQL.")
        return False
    
    def open_cursor(self):
        """Open a clean cursor for query"""
        self.cursor = self.conn.cursor()

    def close_cursor(self):
        """Close the cursor"""
        if self.cursor:
            self.cursor.close()
        else:
            print("/!\ Cursor already closed.")
    
    def close_coonnection(self) -> None:
        """Close the MySql connection"""
        if self.cursor:
            self.cursor.close()
        self.conn.close()

    def clean_cursor(self) -> None:
        """Clean the curosr"""
        if self.cursor:
            self.cursor.close()
        self.cursor = self.conn.cursor()

    #####################################################
    #                                                   #
    #                        City                       #
    #                                                   #
    #####################################################

    def insert_city(self, city: dict) -> None:
        """Insert in the database if the city doesnt not exist """
        self.open_cursor()
        query = "INSERT INTO city (city_name, city_country, city_localisation, city_code, city_departement, city_region) VALUES (%s, %s, %s, %s, %s, %s)"
        self.cursor.execute(query, (city['region'], city['country'], city['loc'], city['code'], city['department'], city['region'],))
        self.conn.commit()
        self.close_cursor()

    def update_city(self, city: dict) -> None:
        """Alter a city in the database
        Need an ID !"""
        query = """
            UPDATE city
            SET city_name = %s, city_country = %s, city_localisation = %s, city_code = %s, city_departement = %s, city_region = %s
            WHERE city_id = %s
        """
        self.open_cursor()
        self.cursor.execute(query, (city['region'], city['country'], city['loc'], city['code'], city['department'], city['region'],))
        self.conn.commit()
        self.close_cursor()

    def delete_city(self, city_id: str) -> None:
        """Delete a city"""
        query = "DELETE FROM city WHERE city_id = %s"
        self.open_cursor()
        self.cursor.execute(query, (city_id,))
        self.conn.commit()
        self.close_cursor()

    def set_cities_default(self) -> None:
        """Upload french cities from the data gouv to the database"""
        with open("init_package/cities.json", 'r', encoding="utf-8") as f:
            json_data = json.load(f)

        for city_dico in json_data['cities']:
            self.insert_city(self.rearange_dico(city_dico, "FR"))

    def set_cities_from_file(self, path: str, country: str) -> None:
        """Add cities from file in json format"""
        if path is None:
            print("No file given")
            return
        if not os.path.exists(path):
            print(f"File {path} doesnt exist")
            return

        with open(path, 'r', encoding="utf-8") as f:
            json_data = json.load(f)

        for city_dico in json_data['cities']:
            self.insert_city(city_dico, country)

    #####################################################
    #                                                   #
    #                        type                       #
    #                                                   #
    #####################################################

    def insert_type(self, type: str) -> None:
        """Insert in the database if the type doesnt not exist"""
        self.open_cursor()
        query = """
            UPDATE type
            SET type_name = %s WHERE
            WHERE type_id = %s
        """
        self.cursor.execute(query, (type),)
        self.conn.commit()
        self.close_cursor()

    def update_type(self, type: dict) -> None:
        """Alter a typein the database
        Need an ID !"""
        query = """
            UPDATE type
            SET type_name = %s
            WHERE type_id = %s
        """
        self.open_cursor()
        self.cursor.execute(query, (type['name'], type['id'],))
        self.conn.commit()
        self.close_cursor()

    def delete_type(self, type_id: str) -> None:
        """Delete a type"""
        query = "DELETE FROM type WHERE type_id = %s"
        self.open_cursor()
        self.cursor.execute(query, (type_id,))
        self.conn.commit()
        self.close_cursor()

    def insert_type_from_file(self, path: str) -> None:

        if path is None or not os.path.exists(path):
            if not os.path.exists(path):
                print(f"File {path} doesnt exist")
            print("Default file loaded")
            with open("init_package/types.json", "r", encoding='utf-8') as f:
                json_data_types = json.load(f)
        else:
            with open(path, "r", encoding='utf-8') as f:
                json_data_types = json.load(f)
            for type in json_data_types:
                query = "INSERT INTO type (type_name) VALUES (%s)"
                self.open_cursor()
                self.cursor.execute(query, (type,))
                print(f"type {type} added")
            

    #####################################################
    #                                                   #
    #                       user                        #
    #                                                   #
    #####################################################

    def insert_user(self, user: dict) -> None:
        """Insert a user in the database"""
        if user.keys() not in self._user_insert:
            print("Error, user's keys do not match the query")
            return
        query = "INSERT INTO users (users_pseudo, users_grade, users_admin, users_mdp) VALUES (%s, %s, %s, %s)"
        self.open_cursor()
        self.cursor.execute(query, (user['pseudo'], user['grade'], user['admin'], user['mdp'],))
        self.conn.commit()
        self.close_cursor()

    def update_user(self, user: dict) -> None:
        """Alter a user in the database
        Need an ID !"""
        if user.keys() not in self._user_insert:
            print("Error, user's keys do not match the query")
            return
        query = """
            UPDATE users
            SET users_pseudo = %s, users_grade = %s, users_admin = %s, users_join = %s, users_mdp = %s
            WHERE users_id = %s
        """
        self.open_cursor()
        self.cursor.execute(query, (user['pseudo'], user['grade'], user['admin'], user['mdp'],))
        self.conn.commit()
        self.close_cursor()

    def delete_user(self, user_id: str) -> None:
        """Delete an user"""
        query = "DELETE FROM users WHERE users_id = %s"
        self.open_cursor()
        self.cursor.execute(query, (user_id,))
        self.conn.commit()
        self.close_cursor()

    #####################################################
    #                                                   #
    #                       spots                       #
    #                                                   #
    #####################################################

    def get_spots_from_mode(self, value: str, mode:str = "code") -> list:
        """Get all spots from mode"""
        # city code mode
        if mode == "code":
            query = """
                SELECT s.*
                FROM spots s
                JOIN city c ON s.spots_ville = c.city_id
                WHERE c.city_code LIKE %s
            """
            self.open_cursor()
            self.cursor.execute(query, (f'{value}%',))
            rows = self.cursor.fetchall()
            self.close_cursor()
        elif mode == "city":
            select_query = """
                SELECT s.*
                FROM spots s
                JOIN city c ON s.spots_ville = c.city_id
                WHERE c.city_name = %s
            """
            self.cursor.execute(select_query, (value,))
            rows = self.cursor.fetchall()
        elif mode == "departments":
            select_query = """
                SELECT s.*
                FROM spots s
                JOIN city c ON s.spots_ville = c.city_id
                WHERE c.city_departement = %s
            """
            self.cursor.execute(select_query, (value,))
            rows = self.cursor.fetchall()
        elif mode == "country":
            select_query = """
                SELECT s.*
                FROM spots s
                JOIN city c ON s.spots_ville = c.city_id
                WHERE c.spots_country = %s
            """
            self.cursor.execute(select_query, (value,))
            rows = self.cursor.fetchall()
        elif mode == "user":
            select_query = "SELECT * FROM spots WHERE spots_user = %s"
            self.cursor.execute(select_query, (value,))
            rows = self.cursor.fetchall()
        elif mode == "type":
            select_query = "SELECT * FROM spots WHERE spots_type = %s"
            self.cursor.execute(select_query, (value,))
            rows = self.cursor.fetchall()
        else:
            print(f"Mode {mode} used doesnt exist")
            return []
        self.close_cursor()
        return rows

    def command_chain(self, command: str) -> list:
        """Parse the command to use multitude command"""
        parsed_com = command.split(',')
        dico_json = {}
        for parsed in parsed_com:
            dico_json[parsed.split(':')[0].strip()] = parsed.split(':')[1].strip()
        print(dico_json)

        union_queries = []
        for key, value in dico_json.items():
            union_queries.append(f"SELECT * FROM spots WHERE {key}={value}")
        combined_query = ' UNION '.join(union_queries)
        
        self.open_cursor()
        self.cursor.execute(combined_query)
        rows = self.cursor.fetchall()
        self.close_cursor()
        return rows

    #####################################################
    #                                                   #
    #                       utils                       #
    #                                                   #
    #####################################################

    @staticmethod
    def rearange_dico(city_dico: dict, country: str = "FR") -> dict:
        """Réarange le dictionnaire suivant le bon format"""
        return {"name": city_dico['region_geojson_name'], "loc": city_dico['latitude']+", "+city_dico['longitude'], "code": city_dico["zip_code"], "department": city_dico["department_name"], "region": city_dico["region_geojson_name"], "country": country}
