<template>
  <div class="employee-management">
    <h1>员工管理</h1>
    <el-card class="employee-list-card">
      <template #header>
        <div class="card-header">
          <span>员工列表</span>
          <div class="header-actions">
            <el-input
              v-model="searchQuery"
              placeholder="搜索员工..."
              class="search-input"
              clearable
            >
              <template #prefix>
                <el-icon><Search /></el-icon>
              </template>
            </el-input>
            <el-select v-model="selectedDepartment" placeholder="部门" class="department-select">
              <el-option label="全部" value="all"></el-option>
              <el-option label="生产部" value="生产部"></el-option>
              <el-option label="技术部" value="技术部"></el-option>
              <el-option label="质检部" value="质检部"></el-option>
            </el-select>
            <el-button type="primary" @click="openAddDialog">
              <el-icon><Plus /></el-icon> 添加员工
            </el-button>
          </div>
        </div>
      </template>
      
      <div style="width: 100%;">
        <el-table :data="filteredEmployees" style="width: 100%;" v-loading="loading" border>
          <el-table-column prop="name" label="姓名" min-width="80"></el-table-column>
          <el-table-column label="部门" min-width="100">
            <template #default="scope">
              <el-tag type="info">{{ scope.row.department }}</el-tag>
            </template>
          </el-table-column>
          <el-table-column prop="position" label="职位" min-width="100"></el-table-column>
          <el-table-column label="状态" min-width="80">
            <template #default="scope">
              <el-tag :type="getStatusType(scope.row.status)">{{ scope.row.status }}</el-tag>
            </template>
          </el-table-column>
          <el-table-column prop="hire_date" label="入职日期" min-width="110"></el-table-column>
          <el-table-column prop="contact" label="联系方式" min-width="160"></el-table-column>
          <el-table-column label="操作" min-width="120" fixed="right">
            <template #default="scope">
              <el-button-group>
                <el-button size="small" type="primary" @click="handleEdit(scope.row)">
                  <el-icon><Edit /></el-icon>
                </el-button>
                <el-button size="small" type="danger" @click="handleDelete(scope.row)">
                  <el-icon><Delete /></el-icon>
                </el-button>
              </el-button-group>
            </template>
          </el-table-column>
        </el-table>
      </div>
    </el-card>

    <!-- 添加/编辑员工对话框 -->
    <el-dialog
      v-model="dialogVisible"
      :title="isEditing ? '编辑员工' : '添加员工'"
      width="500px"
      destroy-on-close
    >
      <el-form 
        :model="employeeForm" 
        :rules="formRules" 
        ref="employeeFormRef" 
        label-width="100px"
        status-icon
      >
        <el-form-item label="姓名" prop="name">
          <el-input v-model="employeeForm.name" placeholder="请输入姓名"></el-input>
        </el-form-item>
        <el-form-item label="部门" prop="department">
          <el-select v-model="employeeForm.department" placeholder="请选择部门" style="width: 100%">
            <el-option label="生产部" value="生产部"></el-option>
            <el-option label="技术部" value="技术部"></el-option>
            <el-option label="质检部" value="质检部"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="职位" prop="position">
          <el-input v-model="employeeForm.position" placeholder="请输入职位"></el-input>
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-select v-model="employeeForm.status" placeholder="请选择状态" style="width: 100%">
            <el-option label="在职" value="在职"></el-option>
            <el-option label="休假" value="休假"></el-option>
            <el-option label="离职" value="离职"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="入职日期" prop="hire_date">
          <el-date-picker 
            v-model="employeeForm.hire_date" 
            type="date" 
            placeholder="请选择入职日期"
            format="YYYY-MM-DD"
            value-format="YYYY-MM-DD"
            style="width: 100%"
          ></el-date-picker>
        </el-form-item>
        <el-form-item label="联系方式" prop="contact">
          <el-input v-model="employeeForm.contact" placeholder="请输入联系方式"></el-input>
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="dialogVisible = false">取消</el-button>
          <el-button type="primary" @click="submitForm" :loading="submitting">
            {{ isEditing ? '保存' : '添加' }}
          </el-button>
        </div>
      </template>
    </el-dialog>

    <!-- 删除确认对话框 -->
    <el-dialog
      v-model="deleteDialogVisible"
      title="确认删除"
      width="400px"
      destroy-on-close
    >
      <div>确定要删除员工 <strong>{{ selectedEmployee?.name }}</strong> 吗？此操作不可恢复。</div>
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="deleteDialogVisible = false">取消</el-button>
          <el-button type="danger" @click="confirmDelete" :loading="deleting">确认删除</el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, reactive } from 'vue';
import { Search, Plus, Edit, Delete } from '@element-plus/icons-vue';
import { ElMessage, ElMessageBox } from 'element-plus';
import axios from 'axios';

// 状态变量
const employees = ref([]);
const loading = ref(false);
const dialogVisible = ref(false);
const deleteDialogVisible = ref(false);
const submitting = ref(false);
const deleting = ref(false);
const isEditing = ref(false);
const selectedEmployee = ref(null);
const employeeFormRef = ref(null);

// 搜索查询
const searchQuery = ref('');

// 选中的部门
const selectedDepartment = ref('all');

// 表单数据
const employeeForm = reactive({
  id: null,
  name: '',
  department: '',
  position: '',
  status: '在职',
  hire_date: '',
  contact: ''
});

// 表单验证规则
const formRules = {
  name: [
    { required: true, message: '请输入姓名', trigger: 'blur' },
    { min: 2, max: 20, message: '长度在 2 到 20 个字符', trigger: 'blur' }
  ],
  department: [
    { required: true, message: '请选择部门', trigger: 'change' }
  ],
  position: [
    { required: true, message: '请输入职位', trigger: 'blur' }
  ],
  status: [
    { required: true, message: '请选择状态', trigger: 'change' }
  ],
  hire_date: [
    { required: true, message: '请选择入职日期', trigger: 'change' }
  ],
  contact: [
    { required: true, message: '请输入联系方式', trigger: 'blur' }
  ]
};

// 过滤员工数据
const filteredEmployees = computed(() => {
  console.log('过滤员工数据', employees.value, searchQuery.value, selectedDepartment.value);
  if (!employees.value || employees.value.length === 0) {
    return [];
  }
  
  return employees.value.filter(employee => {
    // 确保所有字段存在
    if (!employee || !employee.name) return false;
    
    const matchesSearch = searchQuery.value ? 
      employee.name.includes(searchQuery.value) : true;
    const matchesDepartment = selectedDepartment.value === 'all' || 
      employee.department === selectedDepartment.value;
    return matchesSearch && matchesDepartment;
  });
});

// 获取状态标签类型
const getStatusType = (status) => {
  if (status === '在职') return 'success';
  if (status === '休假') return 'warning';
  if (status === '离职') return 'danger';
  return 'info';
};

// 部门点击事件处理
const handleDepartmentClick = (department) => {
  selectedDepartment.value = department;
  console.log('切换到部门', department);
};

// 打开添加对话框
const openAddDialog = () => {
  isEditing.value = false;
  resetForm();
  dialogVisible.value = true;
};

// 处理编辑事件
const handleEdit = (employee) => {
  isEditing.value = true;
  selectedEmployee.value = employee;
  Object.assign(employeeForm, employee);
  dialogVisible.value = true;
};

// 处理删除事件
const handleDelete = (employee) => {
  selectedEmployee.value = employee;
  deleteDialogVisible.value = true;
};

// 确认删除
const confirmDelete = async () => {
  if (!selectedEmployee.value || !selectedEmployee.value.id) return;
  
  deleting.value = true;
  try {
    // 直接使用本地模拟删除
    console.log('使用本地模拟删除');
    const index = employees.value.findIndex(e => e.id === selectedEmployee.value.id);
    if (index !== -1) {
      employees.value.splice(index, 1);
    }
    
    ElMessage.success('员工删除成功');
    deleteDialogVisible.value = false;
  } catch (error) {
    console.error('删除员工失败:', error);
    ElMessage.error('删除员工失败，请重试');
  } finally {
    deleting.value = false;
  }
};

// 重置表单
const resetForm = () => {
  employeeForm.id = null;
  employeeForm.name = '';
  employeeForm.department = '';
  employeeForm.position = '';
  employeeForm.status = '在职';
  employeeForm.hire_date = '';
  employeeForm.contact = '';
  
  if (employeeFormRef.value) {
    employeeFormRef.value.resetFields();
  }
};

// 提交表单
const submitForm = async () => {
  if (!employeeFormRef.value) return;
  
  await employeeFormRef.value.validate(async (valid) => {
    if (!valid) return;
    
    submitting.value = true;
    try {
      // 确保日期格式正确 (确保是YYYY-MM-DD格式)
      if (employeeForm.hire_date && employeeForm.hire_date.includes('T')) {
        employeeForm.hire_date = employeeForm.hire_date.split('T')[0];
      }
      
      if (isEditing.value) {
        // 更新员工 - 直接使用本地模拟更新
        console.log('使用本地模拟更新');
        const index = employees.value.findIndex(e => e.id === employeeForm.id);
        if (index !== -1) {
          employees.value[index] = { ...employeeForm };
        }
        ElMessage.success('员工信息更新成功');
      } else {
        // 添加员工 - 直接使用本地模拟添加
        console.log('使用本地模拟添加');
        const newId = employees.value.length > 0 
          ? Math.max(...employees.value.map(e => e.id)) + 1 
          : 1;
        const newEmployee = { ...employeeForm, id: newId };
        employees.value.push(newEmployee);
        ElMessage.success('员工添加成功');
      }
      
      dialogVisible.value = false;
    } catch (error) {
      console.error('保存员工信息失败:', error);
      ElMessage.error('保存员工信息失败，请重试');
    } finally {
      submitting.value = false;
    }
  });
};

// 获取员工数据
const fetchEmployees = async () => {
  loading.value = true;
  try {
    // 直接使用模拟数据，不尝试API调用
    console.log('使用模拟数据展示');
    
    // 使用模拟数据
    employees.value = [
      {
        id: 1,
        name: '张三',
        department: '生产部',
        position: '车间主管',
        status: '在职',
        hire_date: '2020-05-15',
        contact: '13800138001'
      },
      {
        id: 2,
        name: '李四',
        department: '技术部',
        position: '工程师',
        status: '在职',
        hire_date: '2021-03-10',
        contact: '13800138002'
      },
      {
        id: 3,
        name: '王五',
        department: '质检部',
        position: '质检员',
        status: '休假',
        hire_date: '2019-11-20',
        contact: '13800138003'
      },
      {
        id: 4,
        name: '赵六',
        department: '生产部',
        position: '操作工',
        status: '在职',
        hire_date: '2022-01-05',
        contact: '13800138004'
      },
      {
        id: 5,
        name: '钱七',
        department: '技术部',
        position: '维修工程师',
        status: '离职',
        hire_date: '2018-09-12',
        contact: '13800138005'
      }
    ];
  } finally {
    loading.value = false;
  }
};

// 获取部门数据
const fetchDepartments = async () => {
  // 可以实现获取部门列表的接口
};

// 生命周期钩子
onMounted(async () => {
  console.log('组件已挂载，开始获取员工数据');
  try {
    await fetchEmployees();
    console.log('员工数据获取完成', employees.value);
    // 添加额外调试信息
    console.log('DOM已更新，员工列表状态:', {
      列表数据: employees.value.length,
      过滤数据: filteredEmployees.value.length,
      加载状态: loading.value,
      搜索关键词: searchQuery.value,
      选择部门: selectedDepartment.value
    });
  } catch (error) {
    console.error('员工数据获取失败:', error);
  }
});
</script>

<style scoped>
.employee-management {
  padding: 20px;
  height: 100%;
}

h1 {
  margin-bottom: 20px;
  font-size: 24px;
}

.employee-list-card {
  margin-bottom: 20px;
  height: calc(100% - 60px);
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.header-actions {
  display: flex;
  align-items: center;
  gap: 10px;
}

.search-input {
  width: 200px;
}

.department-select {
  width: 150px;
}

.dialog-footer {
  display: flex;
  justify-content: flex-end;
}

/* 确保表格内容不会导致行高不一致 */
:deep(.el-table .cell) {
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

:deep(.el-table) {
  width: 100% !important;
}

/* 响应式调整 */
@media screen and (max-width: 1200px) {
  .header-actions {
    flex-wrap: wrap;
  }
}
</style>