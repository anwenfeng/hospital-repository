<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Insert title here</title>
    <jsp:include page="/common/mystyle.jsp"></jsp:include>
</head>
<body>
<center><h1>用户信息页面</h1></center><br>
<div class="btn-group" role="group" aria-label="..." id="tabToolBarId">
    <button type="button" class="btn btn-default" onclick='addUserInfo()'>新增用户信息</button>

</div>

<table id="userInfoTableId"></table>
<script type="text/javascript">
    /*页面加载所有的用户信息  */
    $(function(){
        $("#userInfoTableId").bootstrapTable({
            url:"<%=request.getContextPath()%>/user/queryUserList.do",
            method:"post",
            striped: true,  	// 斑马线效果     默认false
            //只允许选中一行
            singleSelect:true,
            //选中行是不选中复选框或者单选按钮
            clickToSelect:true,
            showToggle:true,                    //是否显示详细视图和列表视图的切换按钮
            cardView: false,                    //是否显示详细视图
            uniqueId: "user_id",                 //每一行的唯一标识，一般为主键列
            showColumns: true,                  //是否显示所有的列
            showRefresh: true,                  //是否显示刷新按钮
            minimumCountColumns: 2,     //  最少留两列
            detailView: false,                  //是否显示父子表
            //发送到服务器的数据编码类型
            contentType:'application/x-www-form-urlencoded;charset=UTF-8',   //数据编码纯文本  offset=0&limit=5
            toolbar:'#tabToolBarId',   //  工具定义位置
            columns:[
                {field:'user_id',title:'用户编号',width:50,
                    formatter:function(value,row,index){
                        return "<input type='checkbox' title='"+row.userName+"' name='checkUserInfoName' value='"+value+"'>";
                    }
                },
                {field:'user_name',title:'用户名',width:100},
                {field:'password',title:'密码',width:100},
                {field:'user_id',title:'操作',width:150,
                    formatter:function(value,row,index){
                        var strHtml="";
                        strHtml +='<button type="button" class="btn btn-default" onclick="delUserInfo('+value+')">删除</button>'+
                            '<button type="button" class="btn btn-default" onclick="updateUserInfo('+value+')">修改</button>';
                        return  strHtml;
                    }
                },
            ],
            //传递参数（*）
            queryParams: function(params) {
                var whereParams = {
                    /*
                        分页  自定义的参数         默认传 limit（展示几条）    offset（从第几条开始    起始条数）
                    */
                    "pageSize":params.limit,
                    "startPos":params.offset,
                    //"goodName":$("#proName").val(),
                    //"fodName":params.search,//精确搜索产品名称
                }
                return whereParams;
            },
            //前台--排序字段
            //sortName:'proPrice',
            //sortOrder:'desc',
            //前台--搜索框
            search:true,
            //启动回车键做搜索功能
            searchOnEnterKey:true,
            //分页方式   后台请求的分页方式
            sidePagination:'server',
            pagination: true,                   //是否显示分页（*）
            pageNum: 1,                       //每页的记录行数（*）
            pageSize: 6,                       //每页的记录行数（*）
            pageList: [3, 6, 9,12],        //可供选择的每页的行数（*）
        });
    })
    function searchUser(){
        $("#userInfoTableId").bootstrapTable('refresh',
            {query: {
                    "userName":$("#searchUserNameId").val(),
                    "minUserCreateTime":$("#minTime").val(),
                    "maxUserCreateTime":$("#maxTime").val(),
                }}
        );
    }

    //查询form表单重置
    function userInfoFormReset(){

        document.getElementById("pro_from").reset();
        searchUser();

    }

    function addUserInfo(){

        var addDialog = bootbox.dialog({
            title: '新增用户信息',
            message:getJspHtml("<%=request.getContextPath()%>/view/addUserPage.jsp"),   //调用方法
            buttons:{
                "save":{
                    label: '保存',
                    //自定义样式
                    className: "btn-success",
                    callback: function() {
                        $.ajax({
                            url:"<%=request.getContextPath()%>/addUserInfo.do",
                            type:'post',
                            data:$("#addUserInfoFormId").serialize(),
                            success:function(){
                                bootbox.alert("新增成功");
                                $("#userInfoTableId").bootstrapTable('refresh');
                            },
                            error:function(){
                                bootbox.alert("ajax失败");
                            }
                        });
                    }
                },
                "unSave":{
                    label: '取消',
                    //自定义样式
                    className: "btn-info",
                    callback: function() {
                        // return false;  //dialog不关闭
                    }
                }
            }
        });


    }


    //逻辑删除
    function delUserInfo(userId){

        var flag=confirm("您确定要删除这条用户信息么？")

        if (flag) {
            $.ajax({

                url:"<%=request.getContextPath()%>/delUserInfo.do",
                type:"post",
                data:{"userId":userId},
                dataType:"json",
                success:function(){

                    bootbox.alert("删除成功");

                    $("#userInfoTableId").bootstrapTable('refresh');

                },
                error:function(){

                    alert("系统出错！！！请使用debug调试！！！");

                }


            })
        }

    }



    function getJspHtml(urlStr){
        var  jspHtml = "";
        //async  (默认: true) 默认设置下，所有请求均为异步请求。如果需要发送同步请求，请将此选项设置为 false。
        //注意，同步请求将锁住浏览器，用户其它操作必须等待请求完成才可以执行。
        $.ajax({
            url:urlStr,
            type:'post',
            //同步的ajax
            async:false,
            success:function(data){
                //alert(data);//data--addProduct.jsp页面内容
                jspHtml = data;
            },
            error:function(){
                bootbox.alert("ajax失败");
            }
        });
        return jspHtml;
    }


    //修改用户信息updateUserInfo
    function updateUserInfo(userId){


        var updateDialog = bootbox.dialog({
            title: '修改用户信息',
            message:getJspHtml("<%=request.getContextPath()%>/toUpdateUserInfoPage.do?userId="+userId),   //调用方法
            buttons:{
                "save":{
                    label: '修改',
                    //自定义样式
                    className: "btn-success",
                    callback: function() {
                        $.ajax({
                            url:"<%=request.getContextPath()%>/updateUserInfo.do",
                            type:'post',
                            data:$("#updateUserInfoFormId").serialize(),
                            success:function(){
                                bootbox.alert("修改成功");
                                $("#userInfoTableId").bootstrapTable('refresh');
                            },
                            error:function(){
                                bootbox.alert("ajax失败");
                            }
                        });
                    }
                },
                "unSave":{
                    label: '取消',
                    //自定义样式
                    className: "btn-info",
                    callback: function() {
                        // return false;  //dialog不关闭
                    }
                }
            }
        });


    }


</script>
</body>
</html>