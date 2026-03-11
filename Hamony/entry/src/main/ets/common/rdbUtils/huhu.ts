import relationalStore from '@ohos.data.relationalStore';
export default class RdbUtils{
  private static rdbStore:relationalStore.RdbStore
  static setStore(store:relationalStore.RdbStore){
    RdbUtils.rdbStore=store
  }
  static getStore():relationalStore.RdbStore{
    return RdbUtils.rdbStore
  }
  static executeSql(sql:string):Promise<void>{
    return RdbUtils.getStore().executeSql(sql)
  }
  static insert(tableName:string,data:any):Promise<Number>{
    return RdbUtils.getStore().insert(tableName,data)
  }
}