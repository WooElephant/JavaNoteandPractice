<%--
  Created by IntelliJ IDEA.
  User: augus
  Date: 2021/11/12
  Time: 14:45
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core"  prefix="c"%>>
<html>
<head>
    <title>员工列表</title>
    <%
        pageContext.setAttribute("APP_PATH",request.getContextPath());
    %>
    <link rel="stylesheet" href="${APP_PATH}/static/bootstrap-3.4.1-dist/css/bootstrap.min.css">
    <script src="${APP_PATH}/static/js/jquery-3.4.1.min.js"></script>
    <script type="text/javascript" src="${APP_PATH}/static/bootstrap-3.4.1-dist/js/bootstrap.min.js"></script>
</head>
<body>

    <%--员工添加窗口--%>
    <div class="modal fade" id="empAddModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="myModalLabel">添加员工</h4>
                </div>
                <div class="modal-body">
                    <form class="form-horizontal">
                        <div class="form-group">
                            <label for="empName_input" class="col-sm-2 control-label">员工姓名</label>
                            <div class="col-sm-10">
                                <input type="text" class="form-control" id="empName_input" placeholder="empName" name="empName">
                                <span class="help-block"></span>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-2 control-label">员工性别</label>
                            <div class="col-sm-10">
                                <label for="empGender1_input" class="radio-inline">
                                    <input type="radio" name="gender" id="empGender1_input" value="男" checked="checked"> 男
                                </label>
                                <label for="empGender2_input" class="radio-inline">
                                    <input type="radio" name="gender" id="empGender2_input" value="女"> 女
                                </label>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="empEmail_input" class="col-sm-2 control-label">员工email</label>
                            <div class="col-sm-10">
                                <input type="email" class="form-control" id="empEmail_input" placeholder="xxxxx@xxx.xxx" name="email">
                                <span class="help-block"></span>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="deptName_input" class="col-sm-2 control-label">部门</label>
                            <div class="col-sm-4">
                                <select class="form-control" id="deptName_input" name="dId">

                                </select>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button type="button" class="btn btn-primary" id="emp_save_btn">保存</button>
                </div>
            </div>
        </div>
    </div>

    <%--员工修改窗口--%>
    <div class="modal fade" id="empUpdateModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title">员工修改</h4>
                </div>
                <%--TODO--%>
                <div class="modal-body">
                    <form class="form-horizontal">
                        <div class="form-group">
                            <label for="empName_input" class="col-sm-2 control-label">员工姓名</label>
                            <div class="col-sm-10">
                                <input type="text" class="form-control" id="empName_update_input" placeholder="empName" name="empName">
                                <span class="help-block"></span>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-2 control-label">员工性别</label>
                            <div class="col-sm-10">
                                <label for="empGender1_input" class="radio-inline">
                                    <input type="radio" name="gender" id="empGender1_update_input" value="男" checked="checked"> 男
                                </label>
                                <label for="empGender2_input" class="radio-inline">
                                    <input type="radio" name="gender" id="empGender2_update_input" value="女"> 女
                                </label>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="empEmail_input" class="col-sm-2 control-label">员工email</label>
                            <div class="col-sm-10">
                                <input type="email" class="form-control" id="empEmail_update_input" placeholder="xxxxx@xxx.xxx" name="email">
                                <span class="help-block"></span>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="deptName_input" class="col-sm-2 control-label">部门</label>
                            <div class="col-sm-4">
                                <select class="form-control" id="deptName_update_input" name="dId">

                                </select>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button type="button" class="btn btn-primary" id="emp_update_btn">修改</button>
                </div>
            </div>
        </div>
    </div>


    <div class="container">
        <%--标题--%>
        <div class="row">
            <div class="col-md-12">
                <h1>SSM_CRUD</h1>
            </div>
        </div>

        <%--按钮--%>
        <div class="row">
            <div class="col-md-4 col-md-offset-8">
                <button class="btn btn-primary" id="emp_add_btn">新增</button>
                <button class="btn btn-danger" id="emp_delete_all">删除</button>
            </div>
        </div>
        <%--表格--%>
        <div class="row">
            <div class="col-md-12">
                <table class="table table-hover" id="emps_table">
                    <thead>
                        <tr>
                            <th>
                                <input type="checkbox" id="check_all"/>
                            </th>
                            <th>#</th>
                            <th>empName</th>
                            <th>gender</th>
                            <th>email</th>
                            <th>deptName</th>
                            <th>操作</th>
                        </tr>
                    </thead>
                    <tbody>
                    </tbody>
                </table>
            </div>
        </div>
        <%--分页--%>
        <div class="row">
            <div class="col-md-6" id="page_info_area">

            </div>

            <div class="col-md-6" id="page_nav_area">

            </div>
        </div>
    </div>

    <script type="text/javascript">
        var totalRecord,currentPage;
        //页码加载完成发送ajax请求
        $(function () {
            toPage(1);
        });

        function toPage(num) {
            $.ajax({
                url:"${APP_PATH}/emps",
                data:"pageNum=" + num,
                type:"get",
                success:function (result) {
                    build_emps_table(result);
                    build_page_info(result);
                    build_page_nav(result);
                }
            });
        }

        //数据单元格的构建
        function build_emps_table(result) {
            $("#emps_table tbody").empty();
            var emps = result.extend.pageInfo.list;
            $.each(emps,function (index,item) {
                var checkBoxTd = $("<td><input type='checkbox' class='check_item'/></td>");
                var empIdTd = $("<td></td>").append(item.empId);
                var empNameTd = $("<td></td>").append(item.empName);
                var genderTd = $("<td></td>").append(item.gender);
                var emailTd = $("<td></td>").append(item.email);
                var deptNameTd = $("<td></td>").append(item.department.deptName);
                var editBtn = $("<button></button>").addClass("btn btn-primary btn-sm edit_btn")
                    .append($("<span></span>").addClass("glyphicon glyphicon-pencil").append("编辑"));
                editBtn.attr("empId",item.empId);
                var removeBtn = $("<button></button>").addClass("btn btn-danger btn-sm delete_btn")
                    .append($("<span></span>").addClass("glyphicon glyphicon-trash").append("删除"));
                var btnTd = $("<td></td>").append(editBtn).append(removeBtn);
                $("<tr></tr>").append(checkBoxTd)
                    .append(empIdTd)
                    .append(empNameTd)
                    .append(genderTd)
                    .append(emailTd)
                    .append(deptNameTd)
                    .append(btnTd)
                    .appendTo("#emps_table tbody");
            });
        }

        //分页信息构建
        function build_page_info(result) {
            $("#page_info_area").empty();
            $("#page_info_area").append("当前"+ result.extend.pageInfo.pageNum +"页，共"+
                result.extend.pageInfo.pages +"页，共"+
                result.extend.pageInfo.total+"条记录");
            totalRecord = result.extend.pageInfo.total;
            currentPage = result.extend.pageInfo.pageNum;
        }

        //分页条构建
        function build_page_nav(result) {
            $("#page_nav_area").empty();
            var ul = $("<ul></ul>").addClass("pagination");

            var firstPageLi = $("<li></li>").append($("<a></a>").append("首页"));
            var lastPageLi = $("<li></li>").append($("<a></a>").append("末页"));
            var prePageLi = $("<li></li>").append($("<a></a>").append("&laquo;"));
            var nextPageLi = $("<li></li>").append($("<a></a>").append("&raquo;"));


            if (!result.extend.pageInfo.hasPreviousPage){
                firstPageLi.addClass("disabled");
                prePageLi.addClass("disabled");
            }else {
                firstPageLi.click(function () {
                    toPage(1);
                });
                prePageLi.click(function () {
                    toPage(result.extend.pageInfo.pageNum - 1);
                });
            }

            if (!result.extend.pageInfo.hasNextPage){
                lastPageLi.addClass("disabled");
                nextPageLi.addClass("disabled");
            }else {
                lastPageLi.click(function () {
                    toPage(result.extend.pageInfo.pages);
                });
                nextPageLi.click(function () {
                    toPage(result.extend.pageInfo.pageNum + 1);
                });
            }

            ul.append(firstPageLi).append(prePageLi);

            $.each(result.extend.pageInfo.navigatepageNums,function (index,item) {
                var numLi = $("<li></li>").append($("<a></a>").append(item));
                if (result.extend.pageInfo.pageNum == item){
                    numLi.addClass("active");
                }

                numLi.click(function () {
                    toPage(item);
                })

                ul.append(numLi);
            });

            ul.append(nextPageLi).append(lastPageLi);

            var navELement = $("<nav></nav>").append(ul);
            navELement.appendTo("#page_nav_area");
        }

        //点击新增按钮
        $("#emp_add_btn").click(function () {
            //表单重置
            $("#empAddModal form")[0].reset();
            $("#empAddModal form").removeClass("has-error has-success");
            $("#empAddModal form").find(".help-block").text("");
            //查询部门信息
            getDepts("#deptName_input");
            //弹出窗口
            $("#empAddModal").modal();
        });

        //查部门
        function getDepts(element) {
            $.ajax({
                url: "${APP_PATH}/depts",
                type: "get",
                success: function (result) {
                    $(element).empty();
                    $.each(result.extend.depts,function (index,item) {
                        var optionElement = $("<option></option>").append(item.deptName).attr("value",item.deptId);
                        optionElement.appendTo(element);
                    });
                }
            });
        }

        //校验
        function show_validate_msg(element,status,msg){
            $(element).parent().removeClass("has-success has-error");
            $(element).next("span").text("");

            if (status == "success"){
                $(element).parent().addClass("has-success");
                $(element).next("span").text("");
            }else {
                $(element).parent().addClass("has-error");
                $(element).next("span").text(msg);
            }
        }

        $("#empName_input").change(function () {
            var empName = $("#empName_input").val();
            var regName = /(^[a-zA-Z0-9_-]{3,16}$)|(^[\u2E80-\u9FFF]{2,5})/;
            if(!regName.test(empName)){
                show_validate_msg("#empName_input","error","用户名可以为2-5位中文或3-16位英文，您的输入不合法！");
                $("#emp_save_btn").attr("validateCheck","error");
            }else {
                show_validate_msg("#empName_input","success","");
                $("#emp_save_btn").attr("validateCheck","success");
            }
        })

        $("#empEmail_input").change(function () {

            var value = $("#empEmail_input").val();

            $.ajax({
                url: "${APP_PATH}/checkEmail",
                data: "email=" + value,
                type: "POST",
                success: function (result) {
                    if (result.code == 100){
                        show_validate_msg("#empEmail_input","success","");
                        $("#emp_save_btn").attr("validateCheck","success");
                    }else {
                        show_validate_msg("#empEmail_input","error",result.extend.email_validate);
                        $("#emp_save_btn").attr("validateCheck","error");
                    }
                }
            });
        });

        //保存点击事件
        $("#emp_save_btn").click(function () {

            if($("#emp_save_btn").attr("validateCheck") == "error"){
                return false;
            }

            $.ajax({
                url: "${APP_PATH}/emp",
                type: "POST",
                data: $("#empAddModal form").serialize(),
                success: function (result) {
                    if (result.code == 100){
                        alert("操作成功！");
                        $("#empAddModal").modal("hide");
                        toPage(totalRecord);
                    }else {
                        if (result.extend.errorFields.email != undefined){
                            show_validate_msg("#empEmail_input","error",result.extend.errorFields.email);
                        }
                        if (result.extend.errorFields.empName != undefined){
                            show_validate_msg("#empName_input","error",result.extend.errorFields.empName);
                        }
                    }
                }
            });
        });

        $(document).on("click",".edit_btn",function () {
            getDepts("#deptName_update_input");
            getEmp($(this).attr("empId"));
            //传递ID给模态框中的按钮
            $("#emp_update_btn").attr("empId",$(this).attr("empId"));
            $("#empUpdateModal").modal();
        });

        function getEmp(id) {
            $.ajax({
                url: "${APP_PATH}/emp/" + id,
                type: "GET",
                success: function (result) {
                    var empData = result.extend.emp;
                    $("#empName_update_input").val(empData.empName);
                    $("#empEmail_update_input").val(empData.email);
                    $("#empUpdateModal input[name=gender]").val([empData.gender]);
                    $("#empUpdateModal select").val([empData.dId]);
                }
            });
        }

        $("#emp_update_btn").click(function () {
            if ($("#emp_update_btn").attr("validateCheck") != "success"){
                return false;
            }

            $.ajax({
                url: "${APP_PATH}/emp/" + $(this).attr("empId"),
                type: "POST",
                data: $("#empUpdateModal form").serialize() + "&_method=PUT",
                success: function (result) {
                    alert(result.msg);
                    $("#empUpdateModal").modal("hide");
                    toPage(currentPage);
                }
            });
        });

        $("#empName_update_input").change(function () {
            var empName = $("#empName_update_input").val();
            var regName = /(^[a-zA-Z0-9_-]{3,16}$)|(^[\u2E80-\u9FFF]{2,5})/;
            if(!regName.test(empName)){
                show_validate_msg("#empName_update_input","error","用户名可以为2-5位中文或3-16位英文，您的输入不合法！");
                $("#emp_update_btn").attr("validateCheck","error");
            }else {
                show_validate_msg("#empName_update_input","success","");
                $("#emp_update_btn").attr("validateCheck","success");
            }
        })

        $("#empEmail_update_input").change(function () {

            var value = $("#empEmail_update_input").val();

            $.ajax({
                url: "${APP_PATH}/checkEmail",
                data: "email=" + value,
                type: "POST",
                success: function (result) {
                    if (result.code == 100){
                        show_validate_msg("#empEmail_update_input","success","");
                        $("#emp_update_btn").attr("validateCheck","success");
                    }else {
                        show_validate_msg("#empEmail_update_input","error",result.extend.email_validate);
                        $("#emp_update_btn").attr("validateCheck","error");
                    }
                }
            });
        });

        $(document).on("click",".delete_btn",function () {
            var empName = $(this).parents("tr").find("td:eq(2)").text();
            var empId = $(this).parents("tr").find("td:eq(1)").text();
            if (confirm("确认删除["+ empName +"]吗？")){
                $.ajax({
                    url: "${APP_PATH}/emp/" + empId,
                    method: "DELETE",
                    success: function (result) {
                        alert(result.msg);
                        toPage(currentPage);
                    }
                });
            }
        });

        //全选全不选
        $("#check_all").click(function () {
            var checked = $(this).prop("checked");
            $(".check_item").prop("checked",checked);
        });

        $(document).on("click",".check_item",function () {
            var num = $(".check_item:checked").length;
            if (num == $(".check_item").length){
                $("#check_all").prop("checked",true);
            }else {
                $("#check_all").prop("checked",false);
            }
        });

        $("#emp_delete_all").click(function () {

            var empNames = "";
            var empIds = "";

            $.each($(".check_item:checked"),function () {
                var empName = $(this).parents("tr").find("td:eq(2)").text();
                var empId = $(this).parents("tr").find("td:eq(1)").text();
                empNames = empNames + empName + ",";
                empIds = empIds + empId + "-";
            });

            empNames = empNames.substring(0,empNames.length-1);
            empIds = empIds.substring(0,empIds.length-1);

            if (confirm("确认删除[" + empNames + "]吗？")){
                $.ajax({
                    url: "${APP_PATH}/emp/" + empIds,
                    type: "DELETE",
                    success: function (result) {
                        alert(result.msg);
                        toPage(currentPage);
                    }
                });
            }
        });
    </script>

</body>
</html>
