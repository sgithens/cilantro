define([],function(){var intcomma,intword,suffixes;return suffixes=[[3,"K"],[6,"million"],[9,"billion"],[12,"trillion"],[15,"quadrillion"],[18,"quintillion"],[21,"sextillion"],[24,"septillion"],[27,"octillion"],[30,"nonillion"],[33,"decillion"],[100,"googol"]],intword=function(value){var exp,largeNum,new_value,suffix,_i,_len,_ref;if(value<1e3)return intcomma(value);for(_i=0,_len=suffixes.length;_i<_len;_i++){_ref=suffixes[_i],exp=_ref[0],suffix=_ref[1],largeNum=Math.pow(10,exp);if(value<largeNum*1e3)return new_value=Math.round(value/largeNum*10)/10,""+new_value+" "+suffix}},intcomma=function(value,sep){var arr,i,len;sep==null&&(sep=","),arr=value.toString().split(""),len=arr.length,i=len%3||3;while(i<len)arr.splice(i,0,","),i+=4;return arr.join("")},App.utils={intword:intword,intcomma:intcomma}})