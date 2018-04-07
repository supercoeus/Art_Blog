<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>
<html>

<head>

    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>H+ 后台主题UI框架 - Bootstrap Table</title>
    <meta name="keywords" content="H+后台主题,后台bootstrap框架,会员中心主题,后台HTML,响应式后台">
    <meta name="description" content="H+是一个完全响应式，基于Bootstrap3最新版本开发的扁平化主题，她采用了主流的左右两栏式布局，使用了Html5+CSS3等现代技术">
    <link rel="shortcut icon" href="favicon.ico"> 
    <link href="${pageContext.request.contextPath}/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/font-awesome.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/plugins/bootstrap-table/bootstrap-table.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/animate.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">

</head>

<body class="gray-bg">
    <div class="wrapper wrapper-content animated fadeInRight">
    
        <div class="ibox float-e-margins">
            <div class="ibox-title">
                <h5>博客信息表格</h5>
                <div class="ibox-tools">
                    <a class="collapse-link">
                        <i class="fa fa-chevron-up"></i>
                    </a>
                    <a class="dropdown-toggle" data-toggle="dropdown" href="#">
                        <i class="fa fa-wrench"></i>
                    </a>
                    <ul class="dropdown-menu dropdown-user">
                        <li><a href="#">选项1</a>
                        </li>
                        <li><a href="#">选项2</a>
                        </li>
                    </ul>
                    <a class="close-link">
                        <i class="fa fa-times"></i>
                    </a>
                </div>
            </div>
            <div class="ibox-content">
               <div class="row row-lg">
                 <div class="example">
                      <table id="allBlog" data-mobile-responsive="true">
                               
                      </table>
                    <div id="toolbar">
                    <button class="type btn btn-outline btn-primary" type="button" id="typeButton" value="5">All</button>
					  	<button class="type btn btn-outline btn-primary" type="button" id="typeButton" value="-1">草稿</button>
					  	<button class="type btn btn-outline btn-info"    type="button" id="typeButton" value="1">发布</button>    
					  	<button class="type btn btn-outline btn-danger"  type="button" id="typeButton" value="2">垃圾箱</button>    
					  	<button class="type btn btn-outline btn-success" type="button" id="typeButton" value="3">推荐</button>    
					  	<button class="type btn btn-outline btn-primary" type="button" id="typeButton" value="4">置顶</button>    
						<div class="btn-group">
                                <button data-toggle="dropdown" class="btn btn-outline btn-warning dropdown-toggle">类别 <span class="caret"></span></button>
                                <ul class="dropdown-menu">
                                   
                                </ul>
                            </div>
					</div>  
                 </div>
               </div>
               
            </div>
        </div>
       
    </div>

    <!-- 全局js -->
    <script src="${pageContext.request.contextPath}/js/jquery.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/bootstrap.min.js"></script>

    <!-- 自定义js -->
    <script src="${pageContext.request.contextPath}/js/content.js"></script>

    <!-- Bootstrap table -->
    <script src="${pageContext.request.contextPath}/js/plugins/bootstrap-table/bootstrap-table.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/plugins/bootstrap-table/bootstrap-table-mobile.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/plugins/bootstrap-table/locale/bootstrap-table-zh-CN.min.js"></script>

	<script>
	$(document).ready(function() {
		//var url="../selectGroupLikeBlogListByPage";
		selectBlog();
	}); 
	
	//草稿/发布...按钮绑定查询事件  
    $("#toolbar .type").click(function() { 
 		var statu;
 		var isrecommend;
 		var istop;
 		if($(this).val()<3)
 			statu=$(this).val();
 		if($(this).val()==3)
 			isrecommend=1;
 		if($(this).val()==4)
 			istop=1;
        var params = $('#allBlog').bootstrapTable('getOptions')  
        params.queryParams = function(params) {  
         return{
            pageSize: params.limit,
            page:(params.offset)/params.limit+1,
            title:$(".form-control").val(),
            keyword:$(".form-control").val(),
            status:statu,
            isrecommend:isrecommend,
            istop:istop,
    		}
        }  
        $('#allBlog').bootstrapTable('refresh',params) 
    }); 
	
	//实现点击类别传参数到后台
    $("#toolbar .btn-group .btn").click(function() { 
    	selectBlogType();
    });
	
	  var selectBlogType=function(){
		  var params ={
  				"data":"all"
  		};
			$.ajax({
              url:'../selectBlogType',    
              type:'post',
              data:params,
              dataType:'json',    
              success:function (data) {
              	  var typeName = '';
              	  $(".btn-group").find(".dropdown-menu").html('');
                  for (var i = 0; i < data.length; i++) {
                	  typeName +='<li><a href="javascript:void(0);" onclick="sendType('+data[i].id+')">' + data[i].typename + '</a></li>';
                  }
                  // 初始化数据
                  $(".btn-group").find(".dropdown-menu").append(typeName);
              },    
  		    error:function(){
  		    	alert("上传失败");
  		    }	
          });
	  }
	
	  var sendType=function(type_id){
		  var params = $('#allBlog').bootstrapTable('getOptions')  
	        params.queryParams = function(params) {  
	         return{
	            pageSize: params.limit,
	            page:(params.offset)/params.limit+1,
	            title:$(".form-control").val(),
	            keyword:$(".form-control").val(),
	            'type.id':type_id,
      		  }
	        }  
	        $('#allBlog').bootstrapTable('refresh',params) 
	  }
	  
	  var selectBlog=function(){
		  $('#allBlog').bootstrapTable({
				method: 'post',  
				url: "../selectGroupLikeBlogListByPage", 
				dataType: "json",  
				striped: false,     //使表格带有条纹  
				pagination: true, //在表格底部显示分页工具栏  
				pageSize: 10,  
				pageNumber: 1,
				sortStable:true, 
				sortable:true,
				pageList: [10, 20, 50],  
				idField: "id",  //标识哪个字段为id主键  
				showToggle: false,   //名片格式  
				cardView: false,//设置为True时显示名片（card）布局  
				showColumns: true, //显示隐藏列    
				showRefresh: true,  //显示刷新按钮  
				//singleSelect: true,//复选框只能选择一条记录  
				search: true,//是否显示搜索框
				searchOnEnterKey:true,//设置为 true时，按回车触发搜索方法，否则自动触发搜索方法
				clickToSelect: true,//点击行即可选中单选/复选框  
				queryParams: queryParams, //参数  
				//showFullscreen:true,  //全屏按钮
				//queryParamsType: "limit", //查询参数组织方式
			    sidePagination: "server", //服务端处理分页
			    //silent: true,  //刷新事件必须设置  
			    
			    toolbarAlign:'left',//工具栏对齐方式
			    buttonsAlign:'right',//按钮对齐方式
			    toolbar:'#toolbar',//指定工作栏
			    searchAlign:'right',
			    contentType: "application/x-www-form-urlencoded",
			    formatLoadingMessage: function () {  
			        return "请稍等，正在加载中...";  
			      },  
			      formatNoMatches: function () {  //没有匹配的结果  
			        return "无符合条件的记录";  
			      },  
			    responseHandler: function(res) {
	                return {
	                    "total": res.pageInfo.total,//总页数
	                    "rows": res.pageInfo.list   //数据
	                 };
	            },
			    columns: [
			             {
	                		//title:'全选',
	                		//field:'全选',
	                		//复选框
	                		checkbox:true,
	                		width:'5%',
	                		align:'center',
	                		valign:'middle'
	            		},
		                  {
		                      title: 'ID',
		                      field: 'id',
		                      align: 'center',
		                      valign: 'middle',
		                      width: '5%',
		                      //sortable:true,
		                  }, 
		                  {
		                      title: '标题',
		                      field: 'title',
		                      align: 'center',
		                      valign: 'middle',
		                      width:'15%',
		                  },
		                  {
		                      title: '类别',
		                      field: 'type.typename',
		                      align: 'center',
		                      width:'8%',
		                  },
		                  {
		                      title: '关键字',
		                      field: 'keyword',
		                      align: 'center',
		                      width:'15%',
		                  },
		                  
		                  {
		                      title: '浏览量',
		                      field: 'clicknum',
		                      align: 'center',
		                      width:'5%',
		                      
		                  },
		                  {
		                      title: '评论量',
		                      field: 'commentnum',
		                      align: 'center',
		                      width:'5%',
		                     
		                  },
		                  {
		                      title: '点赞量',
		                      field: 'agreenum',
		                      align: 'center',
		                      width:'5%',
		                      
		                  },
		                  {
		                      title: '博主推荐',
		                      field: 'isrecommend',
		                      align: 'center',
		                      width:'5%',
		                      formatter:function(value,row,index){  
		   	                  if(row.isrecommend==0){
		   	                	return '<button class="btn-xs">否</button> ';  
		   	                  	}else if(row.isrecommend==1){
		   	                  	return '<button class="btn-xs btn-success">是</button>'; 
		   	                  	}
		   	                  	 
		   	                    } 
		                  },
		                  {
		                      title: '状态',
		                      field: 'status',
		                      align: 'center',
		                      width:'7%',
		                      formatter:function(value,row,index){  
		   	                  if(row.status==-1){
		   	                	return '<button class="btn-xs btn-primary">草稿</button>';  
		   	                  	}else if(row.status==1){
		   	                  	return '<button class="btn-xs btn-info">发布</button>'; 
		   	                  	}else if(row.status==2){
		   	                  	return '<button class="btn-xs btn-danger">垃圾</button>'; 
		   	                  	}
		   	                   } 
		                  },
		                  {
		                      title: '发表时间',
		                      field: 'addtime',
		                      align: 'center',
		                      width:'14%',
		                      
		                      formatter:function(value,row,index){  
		                    	 return Format(row.addtime,"yyyy-MM-dd hh:mm:ss");
			   	                 } 
		                  },
		                  {
		                      title: '操作',
		                      field: 'id',
		                      align: 'center',
		                      width:'20%',
		                      formatter:function(value,row,index){
		                    	
		                   var e = '<button class="btn-xs btn-info" onclick="edit(\''+ row.id + '\')">查看</button> ';  
		                   var d = '<button class="btn-xs btn-primary" onclick="del(\''+ row.id +'\')">编辑</button> ';  
		                        return e+d;  
		                    } 
		                  }
		              ]
		      });
	  }
	
	
		
	function queryParams(params){
		
        return{
            //每页多少条数据
        	//pageIndex: params.offset+1,
            pageSize: params.limit,
            page:(params.offset)/params.limit+1,
            title:$(".form-control").val(),
            keyword:$(".form-control").val(),
           
        }
    }
	
	function Format(datetime, fmt) {
	    if (parseInt(datetime) == datetime) {
	        if (datetime.length == 10) {
	            datetime = parseInt(datetime) * 1000;
	        } else if (datetime.length == 13) {
	            datetime = parseInt(datetime);
	        }
	    }
	    datetime = new Date(datetime);
	    var o = {
	        "M+": datetime.getMonth() + 1,                 //月份   
	        "d+": datetime.getDate(),                    //日   
	        "h+": datetime.getHours(),                   //小时   
	        "m+": datetime.getMinutes(),                 //分   
	        "s+": datetime.getSeconds(),                 //秒   
	        "q+": Math.floor((datetime.getMonth() + 3) / 3), //季度   
	        "S": datetime.getMilliseconds()             //毫秒   
	    };
	    if (/(y+)/.test(fmt))
	        fmt = fmt.replace(RegExp.$1, (datetime.getFullYear() + "").substr(4 - RegExp.$1.length));
	    for (var k in o)
	        if (new RegExp("(" + k + ")").test(fmt))
	            fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
	    return fmt;
	}
	</script>
</body>
</html>