package com.augus.crud.controller;

import com.augus.crud.bean.Employee;
import com.augus.crud.bean.Msg;
import com.augus.crud.service.EmployeeService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class EmployeeController {

    @Autowired
    EmployeeService employeeService;

    @RequestMapping("/emps")
    @ResponseBody
    public Msg getEmpsWithJson(@RequestParam(value = "pageNum",defaultValue = "1")Integer pageNum){
        //传入页码以及每页数量
        PageHelper.startPage(pageNum,5);
        List<Employee> emps = employeeService.getAll();

        //使用PageInfo包装结果，第二个参数为连续显示多少页
        PageInfo pageInfo = new PageInfo(emps,5);
        return Msg.success().add("pageInfo",pageInfo);
    }

    @RequestMapping(value = "/emp",method = RequestMethod.POST)
    @ResponseBody
    public Msg saveEmp(@Valid Employee employee, BindingResult result){
        if (result.hasErrors()){
            List<FieldError> fieldErrors = result.getFieldErrors();
            Map<String,String> map = new HashMap<>();
            for (FieldError fieldError : fieldErrors) {
                map.put(fieldError.getField(),fieldError.getDefaultMessage());
            }
            return Msg.fail().add("errorFields",map);
        }else {
            employeeService.saveEmp(employee);
            return Msg.success();
        }
    }

    @ResponseBody
    @RequestMapping("/checkEmail")
    public Msg checkEmail(@RequestParam("email") String email){
        String reg = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$";
        if (!email.matches(reg)){
            return Msg.fail().add("email_validate","您输入的邮箱不合法！");
        }

        boolean b = employeeService.checkEmail(email);
        if (b){
            return Msg.success();
        }else {
            return Msg.fail().add("email_validate","您输入的邮箱已存在！");
        }
    }

    @ResponseBody
    @RequestMapping(value = "/emp/{id}",method = RequestMethod.GET)
    public Msg getEmp(@PathVariable("id") Integer id){
        Employee employee = employeeService.getEmp(id);
        return Msg.success().add("emp",employee);
    }

    @ResponseBody
    @RequestMapping(value = "/emp/{empId}",method = RequestMethod.PUT)
    public Msg updateEmp(Employee employee){
        employeeService.updateEmp(employee);
        return Msg.success();
    }

    @ResponseBody
    @RequestMapping(value = "emp/{ids}",method = RequestMethod.DELETE)
    public Msg deleteEmpById(@PathVariable("ids")String ids){
        if (ids.contains("-")){
            String[] ids_arr = ids.split("-");
            List<Integer> id_list = new ArrayList<>();
            for (String s : ids_arr) {
                int i = Integer.parseInt(s);
                id_list.add(i);
            }
            employeeService.deleteBatch(id_list);
        }else {
            int id = Integer.parseInt(ids);
            employeeService.deleteEmp(id);
        }
        return Msg.success();
    }


}
