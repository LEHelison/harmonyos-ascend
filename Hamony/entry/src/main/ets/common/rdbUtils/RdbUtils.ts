import relationalStore from '@ohos.data.relationalStore';
import Employee from './lalala';
export default class RdbUtils {
  private static rdbStore: relationalStore.RdbStore;
  static setStore(store: relationalStore.RdbStore) {
    RdbUtils.rdbStore = store;
  }
  static queryAll(): Promise<Array<Employee>> {
    let predicates = new relationalStore.RdbPredicates('EMPLOYEE');
    return new Promise<Array<Employee>>((resolve, reject) => {
      RdbUtils.getStore().query(predicates).then((result) => {
        let employees = new Array<Employee>();
        while (result.goToNextRow()) {
        }
        resolve(employees);
      }).catch((error) => {
        reject(error)
      })
    })
  }
  static executeSql(sql: string): Promise<void> {
    return RdbUtils.getStore().executeSql(sql);
  }
  static insert(tableName: string, data: any): Promise<number> {
    return RdbUtils.getStore().insert(tableName, data);
  }
  static getStore(): relationalStore.RdbStore {
    return RdbUtils.rdbStore;
  }
}
