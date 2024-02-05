#!/usr/bin/bash 


awk ' {
      gsub(/[a-zA-Z]*\<pdf-tool\>[a-zA-Z]*/, "\033[1;35m&\033[0m");  
    
      gsub(/OPTIONS|NAME|DESCRIPTION|OVERVIEW|REQUIRES|CONTRIBUTOR|SYNOPSIS|ENSURE|NOTE|AUTHOR/, "\033[1;37m&\033[0m");
    
      gsub(/https:\/\/github.com\/baldeuniversel\/linux.git/, "\033[1;32m&\033[0m"); 
    
      gsub(/Baldé|Amadou|diallois@protonmail.com|Diallo|Ismaila|baldeuniversel@protonmail.com/, "\033[1;32m&\033[0m");
    
      gsub(/\<--input\>|\<-i\>|\<--from\>|\<-f\>|\<--to\>|\<-t\>|\<--destination\>|\<-d\>/, "\033[1;36m&\033[0m");
    
      gsub(/\<--source\>|\<-s\>|\<--scope\>|\<--after-page\>|\<-a\>|\<--cardinal\>|\<-c\>|\<--level\>|\<-l\>/, "\033[1;36m&\033[0m");
    
      gsub(/\<--extract\>|\<--number\>|\<--concat\>|\<--include\>|\<--exclude\>/, "\033[1;96m&\033[0m");
      
      gsub(/\<--burst\>|\<--encrypt\>|\<--decrypt\>|\<--rotate\>/, "\033[1;96m&\033[0m");

      gsub(/\--stamp|\--doc|\--help|\--version/, "\033[1;96m&\033[0m");

    } 1 ' $1
