import Employee from '../common/rdbUtils/lalala';
import RdbUtils from '../common/rdbUtils/RdbUtils';

interface GeneratedObjectLiteralInterface_1 {
  'username': string;
  'passname': string;
}

@Entry
@Component
struct Index {
  build() {
    Row() {
      Column() {
        Button('创建数据库表')
          .onClick(() => {
            const SQL_CREATE_TABLE = 'CREATE TABLE IF NOT EXISTS EMPLOYEE (ID INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL, author INTEGER, jianjie REAL, CODES BLOB)'; // 建表Sql语句
            RdbUtils.executeSql(SQL_CREATE_TABLE)
              .then(() =>{
                openDialog('successfully created table')
              }).catch((err:Error) => {
              openDialog(err.message);
            })
          })
        Button('存入数据')
          .onClick(() => {
            const valueBucket: GeneratedObjectLiteralInterface_1 = {
              'username': 'zhr',
              'passname': '12345678',
            };
            RdbUtils.insert('EMPLOYEE', valueBucket)
              .then((updateNumber) => {
                openDialog('已存入数据:' + updateNumber)
              }).catch((error:Error) => {
              openDialog('error: ' + error)
            })
          })
        Button('')
          .onClick(() => {
            RdbUtils.queryAll()
              .then((employees: Array<Employee>) => {
                openDialog('employees: ' + JSON.stringify(employees))
              }).catch((error:Error) => {
              openDialog('error' + error.toString())
            })
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}
function openDialog(text: string) {
  AlertDialog.show(
    {
      message: text,
      autoCancel: true,
      alignment: DialogAlignment.Bottom,
      offset: { dx: 0, dy: -20 },
    }
  )
}