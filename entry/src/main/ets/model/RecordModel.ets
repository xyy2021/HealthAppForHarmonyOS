/**
 * 数据库建表语句
 */

const CREATE_TABLE_SQL: string = `
 CREATE TABLE IF NOT EXISTS record (
   id INTEGER PRIMARY KEY AUTOINCREMENT,
   type_id INTEGER NOT NULL,
   item_id INTEGER NOT NULL,
   amount DOUBLE NOT NULL,
   create_time INTEGER NOT NULL
 )
 `


class RecordModel {
}

let recordModel = new RecordModel()

export default recordModel as RecordModel