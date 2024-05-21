import common from '@ohos.app.ability.common';
import relationalStore from '@ohos.data.relationalStore';
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

  insert(tableName: string, obj: any) {
    //构建新增数据
    let value = {}
    //新增
    this.rdbStore.insert(tableName, value)
  }
}


let dbUtil: DbUtil = new DbUtil();

export default dbUtil as DbUtil