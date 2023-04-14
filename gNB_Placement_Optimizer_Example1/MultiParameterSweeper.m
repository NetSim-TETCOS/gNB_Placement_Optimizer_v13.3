 
% Set the path of 64 bit NetSim Binaries to be used for simulation.
NETSIM_PATH = "C:\Users\TEST\Documents\NetSim\Workspaces\gnb optimization\bin_x64";
LICENSE_PATH = "C:\Program Files\NetSim\Pro_v13_3\bin\";
% Set NETSIM_AUTO environment variable to avoid keyboard interrupt at the end of each simulation
setenv('NETSIM_AUTO','1');
% Create IOPath directory to store the input Configuration.netsim file and
% the simulation output files during each iteration if not

if(~isfolder('IOPath'))
    mkdir IOPath
end

% Create Data directory to store the Configuration.netsim and the
% Metrics.xml files associated with each iteration if not
if(~isfolder('Data'))
 mkdir Data
end

% Clear the IOPath folder if it has any files created during previous
delete('IOPath\*')
delete('Data\*')

% Delete result.csv file if it already exists
if(isfile('result.csv'))
  delete result.csv
end

% create a folder with name as year-month-day-hour.minute.seconds inside the data folder 
today = datestr(now,'dd-mm-yyyy-HH.MM.SS');
mkdir('Data',today)


%gNB_x =[2000, 2200, 2400, 1800, 2000, 2200, 2400, 2600, 2800, 3000, 1600, 1800, 2000, 2200, 2400, 2600, 2800, 3000, 3200, 1400, 1600, 1800, 2000, 2200, 2400, 2600, 2800, 3000, 3200, 3400, 1200, 1400, 1600, 1800, 2000, 2200, 2400, 2600, 2800, 3000, 3200, 3400, 3600, 1000, 1200, 1400, 1600, 1800, 2000, 2200, 2400, 2600, 2800, 3000, 3200, 3400, 3600, 3800, 800, 1000, 1200, 1400, 1600, 1800, 2000, 2200, 2400, 2600, 2800, 3000, 3200, 3400, 3600, 3800, 600, 800, 1000, 1200, 1400, 1600, 1800, 2000, 2200, 2400, 2600, 2800, 3000, 3200, 3400, 3600, 400, 600, 800, 1000, 1200, 1400, 1600, 1800, 2000, 2200, 2400, 2600, 2800, 3000, 3200, 3400, 3600, 400, 600, 800, 1000, 1200, 1400, 1600, 1800, 2000, 2200, 2400, 2600, 2800, 3000, 3200, 3400, 400, 600, 800, 1000, 1200, 1400, 1600, 1800, 2000, 2200, 2400, 2600, 2800, 3000, 3200, 3400, 400, 600, 800, 1000, 1200, 1400, 1600, 1800, 2000, 2200, 2400, 2600, 2800, 3000, 3200, 3400, 400, 600, 800, 1000, 1200, 1400, 1600, 1800, 2000, 2200, 2400, 2600, 2800, 3000, 3200, 400, 600, 800, 1000, 1200, 1400, 1600, 1800, 2000, 2200, 2400, 2600, 2800, 3000, 3200, 600, 800, 1000, 1200, 1400, 1600, 1800, 2000, 2200, 2400, 2600, 2800, 3000, 3200, 800, 1000, 1200, 1400, 1600, 1800, 2000, 2200, 2400, 2600, 2800, 3000, 1000, 1200, 1400, 1600, 1800, 2000, 2200, 2400, 2600, 1000, 1200, 1400, 1600, 1800, 2000, 2200];
%gNB_y =[200, 200, 200, 400, 400, 400, 400, 400, 400, 400, 600, 600, 600, 600, 600, 600, 600, 600, 600, 800, 800, 800, 800, 800, 800, 800, 800, 800, 800, 800, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1200, 1200, 1200, 1200, 1200, 1200, 1200, 1200, 1200, 1200, 1200, 1200, 1200, 1200, 1200, 1400, 1400, 1400, 1400, 1400, 1400, 1400, 1400, 1400, 1400, 1400, 1400, 1400, 1400, 1400, 1400, 1600, 1600, 1600, 1600, 1600, 1600, 1600, 1600, 1600, 1600, 1600, 1600, 1600, 1600, 1600, 1600, 1800, 1800, 1800, 1800, 1800, 1800, 1800, 1800, 1800, 1800, 1800, 1800, 1800, 1800, 1800, 1800, 1800, 2000, 2000, 2000, 2000, 2000, 2000, 2000, 2000, 2000, 2000, 2000, 2000, 2000, 2000, 2000, 2000, 2200, 2200, 2200, 2200, 2200, 2200, 2200, 2200, 2200, 2200, 2200, 2200, 2200, 2200, 2200, 2200, 2400, 2400, 2400, 2400, 2400, 2400, 2400, 2400, 2400, 2400, 2400, 2400, 2400, 2400, 2400, 2400, 2600, 2600, 2600, 2600, 2600, 2600, 2600, 2600, 2600, 2600, 2600, 2600, 2600, 2600, 2600, 2800, 2800, 2800, 2800, 2800, 2800, 2800, 2800, 2800, 2800, 2800, 2800, 2800, 2800, 2800, 3000, 3000, 3000, 3000, 3000, 3000, 3000, 3000, 3000, 3000, 3000, 3000, 3000, 3000, 3200, 3200, 3200, 3200, 3200, 3200, 3200, 3200, 3200, 3200, 3200, 3200, 3400, 3400, 3400, 3400, 3400, 3400, 3400, 3400, 3400, 3600, 3600, 3600, 3600, 3600, 3600, 3600];

% create a csv file to log the output metrics for analysis csvfile 
fileid=fopen('results.csv','w');

% Add headings to the CSV file 
k=fprintf(fileid,'gNB(x),gNB(y),Throughput(Mbps)');
fclose(fileid);

% Iterate based on the number of time simulation needs to be run and the
for i = 1 : 1

    if(isfile('Configuration.netsim'))
     delete Configuration.netsim
    end

    if(isfile("IOPath\\Configuration.netsim"))
    delete('IOPath\Configuration.netsim')
    end 
 
    if(isfile('IOPath\Metrics.xml'))
        delete('IOPath\Metrics.xml')
    end
   
    %Call ConfigWriter.exe with arguments as per the number of variable parameters in the input.xml file
    cmd='ConfigWriter.exe '+string(gNB_x(i))+' '+string(gNB_y(i));
    disp(cmd)
    system(cmd);
     
    %Copy the Configuration.netsim file generated by ConfigWriter.exe to IOPath directory 
    if(isfile('Configuration.netsim'))
        copyfile('Configuration.netsim','IOPath');
    end
        
    strIOPATH=pwd+"\IOPath";

    %Run NetSim via CLI mode by passing the apppath iopath and license information to the NetSimCore.exe
    cmd="start ""NetSim_Multi_Parameter_Sweeper"" /wait /d "+"""" +NETSIM_PATH+ """ " + "NetSimcore.exe -apppath """... 
    +NETSIM_PATH+ """ -iopath """ +strIOPATH +""" -license 5053@192.168.0.9";


    disp(cmd)
    [status,cmdout] = system(cmd);
    
    %Create a copy of the output Metrics.xml file for writing the result log
    if(isfile('IOPath\Metrics.xml'))
        copyfile('IOPath\Metrics.xml','Metrics.xml');
    end
    
    if(isfile('IOPath\Metrics.xml'))
       system("MetricsCsv.exe IOPath");
    end
     
    %If only one output parameter is to be read only one Script text file with name Script.txt to be provided
    %If more than one output parameter is to be read, multiple Script text file with name Script1.txt, Script2.txt,...
    %...,Scriptn.txt to be provided

    OUTPUT_PARAM_COUNT=10;
    sum_throughput=0;
  
    if(isfile('IOPath\Metrics.xml'))
        %Write the value of the variable parameters in the current
        %iteration to the result log
        fileid=fopen('results.csv','a');
        k=fprintf(fileid,'\n%f,%f,',gNB_x(i),gNB_y(i));
        fclose(fileid);
        if (OUTPUT_PARAM_COUNT==1)
            %Call the MetricsReader.exe passing the name of the output log
            %file for updating the log based on script.txt
             system("MetricsReader.exe results.csv");
        else
            for n = 1: OUTPUT_PARAM_COUNT
                movefile("Script"+string(n)+".txt","Script.txt");
                [status,cmdout]=system("MetricsReader.exe throughput.txt");
                fileID=fopen('throughput.txt','r');
                throughput=fscanf(fileID,"%f");
                fclose(fileID);
                sum_throughput=sum_throughput+throughput;
                fileID=fopen('throughput.txt','w');
                fclose(fileID);
                movefile("Script.txt","Script"+string(n)+".txt");
            end
             fileid=fopen('results.csv','a');
             k=fprintf(fileid,'%f,',sum_throughput);
             fclose(fileid);
        end
        % 
    else
       %Update the output Metric as crash if Metrics.xml file is missing
       fileid=fopen('results.csv','a');
       k=fprintf(fileid,'\n%f,%f,crash',gNB_x(i),gNB_y(i));
       fclose(fileid);
   end
    % Name of the Output folder to which the results will be saved
     OUTPUT_PATH = "Data\"+today+"\Output_"+string(i);
     
    % If not os.path.exists(OUTPUT_PATH): os.makedirs(OUTPUT_PATH)
    if(~isfolder(OUTPUT_PATH))
      mkdir(OUTPUT_PATH)
    end

    % Create a copy of result.csv file present in sweep folder to date-time 
    if(isfile('results.csv'))
     copyfile('results.csv', "Data\"+today)
    end      
   
    % Create a copy of all files that is present in IOPATH to the desired output location  
    movefile('IOPath\*',OUTPUT_PATH)

    % Delete Configuration.netsim file created during the last iteration
    if(isfile("Configuration.netsim"))
      delete('Configuration.netsim')
    end 

    if(isfile('Metrics.xml'))
      delete('Metrics.xml')
    end
end
