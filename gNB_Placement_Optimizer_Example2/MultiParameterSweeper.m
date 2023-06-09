function [gNB_Pos] = MultiParameterSweeper(gNB_Coord,sweep_input,Assoc_gNB_ID,gNB_ID,K)
% Set the path of 64 bit NetSim Binaries to be used for simulation.
NETSIM_PATH = "C:\Users\TEST\Documents\NetSim\Workspaces\gnb optimization\bin_x64";
%LICENSE_PATH = "C:\Program Files\NetSim\Pro_v13_3\bin\";
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
%delete('Data\*')

% Delete result.csv file if it already exists
if(isfile('result.csv'))
    delete result.csv
end

% create a folder with name as year-month-day-hour.minute.seconds inside the data folder
today = datestr(now,'dd-mm-yyyy-HH.MM.SS');
today="K_"+string(K)+"_gNB_"+string(gNB_ID)+"_"+today;
mkdir('Data',today)


% gNB_x =[200,400,600,800,1000,1200,200,400,600,800,1000,1200,200,400,600,800,1000,1200,1400,400,600,800,1000,1200,1400,800,1000,1200,1400,1600,1400,1600];
% gNB_y =[600,600,600,600,600,600,800,800,800,800,800,800,1000,1000,1000,1000,1000,1000,1000,1200,1200,1200,1200,1200,1200,1400,1400,1400,1400,1400,1600,1600];

% create a csv file to log the output metrics for analysis csvfile
fileid=fopen('results.csv','w');

% Add headings to the CSV file
fprintf(fileid,'Case,gNB(x),gNB(y),Current_Cell_Agg_Throughput(Mbps),Total_Agg_Throughput(Mbps)');
fclose(fileid);

% Iterate based on the number of time simulation needs to be run and the
max_throughput=0.0;
total_throughput=0.0;
best_gNB_Pos=zeros(1,2);
for i = 1 : size(sweep_input,1)

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
    cmd="ConfigWriter.exe ";
    for s = 1:10
        if(s~=gNB_ID)
            cmd=cmd+string(gNB_Coord(s,1))+' '+string(gNB_Coord(s,2))+' ';
        else
            cmd=cmd+string(sweep_input(i,1))+' '+string(sweep_input(i,2))+' ';
        end
    end
    %disp(cmd)
    system(cmd);

    %Copy the Configuration.netsim file generated by ConfigWriter.exe to IOPath directory
    if(isfile('Configuration.netsim'))
        copyfile('Configuration.netsim','IOPath');
    end

    strIOPATH=pwd+"\IOPath";

    %Run NetSim via CLI mode by passing the apppath iopath and license information to the NetSimCore.exe
    cmd="start ""NetSim_Multi_Parameter_Sweeper"" /wait /d "+"""" +NETSIM_PATH+ """ " + "NetSimcore.exe -apppath """...
        +NETSIM_PATH+ """ -iopath """ +strIOPATH +""" -license 5053@192.168.0.9";


    %disp(cmd)
    system(cmd);

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

    aggregate_throughput=0.0;
    curr_gNB_aggr_throughput=0.0;
    %OUTPUT_PARAM_COUNT=1;


    if(isfile('IOPath\Metrics.xml'))
        for app=1:100

            fileID=fopen('Script.txt','w');
            if(fileID~=-1)
                fprintf(fileID,"MENU NAME=""Application_Metrics""\nTABLE NAME=""Application_Metrics""\nSET A=""Throughput (Mbps)"" WHERE ""Application Id""="""+string(app)+"""");
                fclose(fileID);
            end
            if(isfile('throughput.txt'))
                delete throughput.txt
                fileID=fopen('throughput.txt','w');
                fclose(fileID);
            end
            system("MetricsReader.exe throughput.txt>NUL");
            fileID=fopen('throughput.txt','r');
            formatSpec='%f';
            if(fileID~=-1)
                out=fscanf(fileID,formatSpec);
                fclose(fileID);
            end
            aggregate_throughput=aggregate_throughput+out;
            if(Assoc_gNB_ID(app)==gNB_ID)
                curr_gNB_aggr_throughput=curr_gNB_aggr_throughput+out;
            end
        end
        %update max throughput and gNB position
        if(curr_gNB_aggr_throughput>max_throughput)
            max_throughput=curr_gNB_aggr_throughput;
            total_throughput=aggregate_throughput;
            best_gNB_Pos(1)=sweep_input(i,1);
            best_gNB_Pos(2)=sweep_input(i,2);
        end
        fileid=fopen('results.csv','a');
        if(fileid)
            fprintf(fileid,'\n%d,%f,%f,%f,%f',i,sweep_input(i,1),sweep_input(i,2),curr_gNB_aggr_throughput,aggregate_throughput);
            fclose(fileid);
        end
        %
    else
        %Update the output Metric as crash if Metrics.xml file is missing
        fileid=fopen('results.csv','a');
        if(fileid)
            fprintf(fileid,'\n%d,%f,%f,crash,crash',i,sweep_input(i,1),sweep_input(i,2));
            fclose(fileid);
        end
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

%update best gNB pos for this iteration
if(gNB_ID~=0)
    gNB_Coord(gNB_ID,1)=best_gNB_Pos(1);
    gNB_Coord(gNB_ID,2)=best_gNB_Pos(2);
end

fileid=fopen('results.csv','a');
if(fileid)
    fprintf(fileid,'\nBest,%f,%f,%f,%f',best_gNB_Pos(1),best_gNB_Pos(2),max_throughput,total_throughput);
    fclose(fileid);
end

if(isfile('results.csv'))
    copyfile('results.csv', "Data\"+today)
end

%update output parameters
gNB_Pos=gNB_Coord;

end

