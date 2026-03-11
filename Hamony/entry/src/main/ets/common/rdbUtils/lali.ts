import relationalStore from '@ohos.data.relationalStore';
export default class RdbUtils{
  private static rdbStore:relationalStore.RdbStore
  static setStore(store:relationalStore.RdbStore){
    RdbUtils.rdbStore = store
  }
  static getstore():relationalStore.RdbStore{
    return RdbUtils.rdbStore
  }
  static executeSql(sql:string):Promise<void>{
    return RdbUtils.getstore().executeSql(sql)
  }
  static insert(tableName:string,data:any):Promise<number>{
    return RdbUtils.getstore().insert(tableName,data)
  }
}
