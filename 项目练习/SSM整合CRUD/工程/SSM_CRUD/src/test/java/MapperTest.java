import com.augus.crud.bean.Department;
import com.augus.crud.bean.Employee;
import com.augus.crud.dao.DepartmentMapper;
import com.augus.crud.dao.EmployeeMapper;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:applicationContext.xml"})
public class MapperTest {

    @Autowired
    DepartmentMapper departmentMapper;

    @Autowired
    EmployeeMapper employeeMapper;

    @Test
    public void testCRUD(){
        departmentMapper.insertSelective(new Department(null,"服务部"));
        employeeMapper.insertSelective(new Employee(null,"李四","男","lisi@163.com",102));
    }
}
