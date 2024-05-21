import common from '@ohos.app.ability.common';
import relationalStore from '@ohos.data.relationalStore';
import { ColumnInfo, ColumnType } from '../bean/ColumnInfo';
import Logger from './Logger';

const DB_FILENAME: string = 'HeiMaHealthy.db'

class DbUtil {
  rdbStore: relationalStore.RdbStore

  initDB(context: common.UIAbilityContext): Promise<void> {
    let config: relationalStore.StoreConfig = {
      name: DB_FILENAME,
      securityLevel: relationalStore.SecurityLevel.S1
    }
    return new Promise<void>((resolve, reject) => {
      relationalStore.getRdbStore(context, config)
        .then(rdbStore => {
          this.rdbStore = rdbStore
          Logger.debug('rdbStore 初始化完成！')
          resolve()
        })
        .catch(reason => {
          Logger.debug('rdbStore 初始化异常', JSON.stringify(reason))
          reject(reason)
        })
    })
  }

  createTable(createSQL: string): Promise<void> {
    return new Promise((resolve, reject) => {
      this.rdbStore.executeSql(createSQL)
        .then(() => {
          Logger.debug('创建表成功', createSQL)
          resolve()
        })
        .catch(err => {
          Logger.error('创建表失败,' + err.message, JSON.stringify(err))
          reject(err)
        })
    })
  }

  insert(tableName: string, obj: any, columns: ColumnInfo[]) {
    return new Promise((resolve, reject) => {
      //构建新增数据
      let value = this.buildValueBucket(obj, columns)
      //新增
      this.rdbStore.insert(tableName, value, (err, id) => {
        if (err) {
          Logger.debug('新增失败:', JSON.stringify(err))
          reject(err)
        } else {
          Logger.debug('新增成功，新增id:', id.toString())
          resolve(id)
        }
      })
    })
  }

  delete(predicates: relationalStore.RdbPredicates) {
    return new Promise((resolve, reject) => {
      this.rdbStore.delete(predicates, (err, rows) => {
        if (err) {
          Logger.debug('删除失败:', JSON.stringify(err))
          reject(err)
        } else {
          Logger.debug('删除成功，删除id:', rows.toString())
          resolve(rows)
        }
      })
    })
  }

  queryForList<T>(predicates: relationalStore.RdbPredicates, columns: ColumnInfo[]): Promise<T[]> {
    return new Promise((resolve, reject) => {
      this.rdbStore.query(predicates, columns.map(info => info.columnName), (err, results) => {
        if (err) {
          Logger.debug('查询失败:', JSON.stringify(err))
          reject(err)
        } else {
          Logger.debug('查询成功:', results.rowCount.toString())
          resolve(this.parseResultSet(results, columns))
        }
      })
    })
  }


  parseResultSet<T>(result: relationalStore.ResultSet, columns: ColumnInfo[]): T[] {
    //1.声明最终返回结果
    let arr = []
    // 2. 判断是否有结果
    if (result.rowCount <= 0) {
      return arr
    }
    while (!result.isAtLastRow) {
      result.goToNextRow()
      let obj = {}
      columns.forEach(info => {
        let val = null
        switch (info.type) {
          case ColumnType.LONG:
            val = result.getLong(result.getColumnIndex(info.columnName))
            break
          case ColumnType.DOUBLE:
            val = result.getDouble(result.getColumnIndex(info.columnName))
            break
          case ColumnType.STRING:
            val = result.getString(result.getColumnIndex(info.columnName))
            break
          case ColumnType.BLOB:
            val = result.getBlob(result.getColumnIndex(info.columnName))
            break
        }
        obj[info.name] = val
      })
      //将对象填入数组
      arr.push(obj)
    }
    return arr

  }

  buildValueBucket(obj: any, columns: ColumnInfo[]): relationalStore.ValuesBucket {
    let value = {}
    columns.forEach(info => {
      let val = obj[info.name]
      if (typeof val !== 'undefined') {
        value[info.columnName] = val
      }
    })
    return value
  }
}


let dbUtil: DbUtil = new DbUtil();

export default dbUtil as DbUtil