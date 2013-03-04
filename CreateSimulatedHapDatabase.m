function CreateSimulatedHapDatabase
%CreateSimulatedHapDatabase create a database for HAP_Analysis
% Simulated cortisol time-series are converted to an internal database 
% format for the HAP_Analysis program. 
% 
% The program is adapted from the program used to generate the original 
% data format used in the current HAP_Analysis program.  No attempt is made
% to create a general pupose program. It is expected that program can be
% quickly adapted to convert other MATALB accessible data sources into the
% HAP data format.
%
% An example of the hormone database structure follow:
%
%          description: 'Adler cortisol data'
%         subject_info: [1x2 struct]
%         subject_data: {2x1 cell}
%                    T: 1440
%              delta_t: 10
%           conditions: {'sleep'  'wake'}
%               groups: {'C'  'F'}
%         num_subjects: 2
%                units: 'ug/dL'
%     
%  Additional 
%
% ---------------------------------------------
% Dennis A. Dean, II, Ph.D
%
% Program for Sleep and Cardiovascular Medicine
% Brigam and Women's Hospital
% Harvard Medical School
% 221 Longwood Ave
% Boston, MA  02149
%
% File created: February 24, 2013
% Last updated: March 2, 2013
%    
% Copyright © [2013] The Brigham and Women's Hospital, Inc. THE BRIGHAM AND 
% WOMEN'S HOSPITAL, INC. AND ITS AGENTS RETAIN ALL RIGHTS TO THIS SOFTWARE 
% AND ARE MAKING THE SOFTWARE AVAILABLE ONLY FOR SCIENTIFIC RESEARCH 
% PURPOSES. THE SOFTWARE SHALL NOT BE USED FOR ANY OTHER PURPOSES, AND IS
% BEING MADE AVAILABLE WITHOUT WARRANTY OF ANY KIND, EXPRESSED OR IMPLIED, 
% INCLUDING BUT NOT LIMITED TO IMPLIED WARRANTIES OF MERCHANTABILITY AND 
% FITNESS FOR A PARTICULAR PURPOSE. THE BRIGHAM AND WOMEN'S HOSPITAL, INC. 
% AND ITS AGENTS SHALL NOT BE LIABLE FOR ANY CLAIMS, LIABILITIES, OR LOSSES 
% RELATING TO OR ARISING FROM ANY USE OF THIS SOFTWARE.
%

%-------------------------------------------- Load Simulated Data Structure
% Simulated data form
simulatedDataFile = 'constantCortisolAmplitudeSimulation2.mat';
load 'constantCortisolAmplitudeSimulation2.mat';

% Show data formats
SimulatedSubjectID = ...
    {'Y025'; 'Y050'; 'Y075'; 'Y100'; 'Y150'; 'Y250'; 'Y250'; 'Y500'};

% Concentration Amplitude
Y025 = Y025;      Y050 = Y050;      Y075 = Y075;      Y100 = Y100;
Y150 = Y150;      Y250 = Y250;      Y250 = Y250;      Y500 = Y500;
Y = {Y025; Y050; Y075; Y100; Y150; Y250; Y250; Y500};

% Concentration Timing
t025 = t025;      t050 = t050;      t075 = t075;      t100 = t100;
t150 = t150;      t250 = t250;      t250 = t250;      t500 = t500;
t = {t025; t050; t075; t100; t150; t250; t250; t500};

% Cortisol Parameters
cortStruct025 = cortStruct025;      cortStruct050 = cortStruct050;      
cortStruct075 = cortStruct075;      cortStruct100 = cortStruct100;
cortStruct150 = cortStruct150;      cortStruct250 = cortStruct250;      
cortStruct250 = cortStruct250;      cortStruct500 = cortStruct500;
cortStruct = {...
      cortStruct025; cortStruct050; cortStruct075; cortStruct100;...
      cortStruct150; cortStruct250; cortStruct250; cortStruct500};

%--------------------------------------- Create HAP Analysis Data Structure
% Values for simulated data
description = 'Simulated Cortisol Data'; 
T = 1440;         % Length of time series in minutes
delta_t = 1;      % time increment in 1 minute
conditions = {'sleep'  'wake'};
groups = {'S'};
num_subjects = 6;
units = 'ug/dL';

%---------------------------------------------------- Create data structure
% Create subject data information
subject_data = {};
for s = 1:num_subjects
    % Create subject data structure
    data.labels = ...
        {'fn_subject_id'  'time_min'  'time_labtime'  'concentration'};
    data.fn_sub_id = sprintf('simulated data ',s);
    data.t = t{s};
    data.t_lab = t{s};
    data.Y = Y{s};
    
    % Store subject data structure
    subject_data{s} = data;
end      

%------------------------------------- Create subject information structure
% Create subject information structure
subject_info = [];
for s = 1:num_subjects
    subject_info(s).subject_descriptor_text = ...
        sprintf('Sim Cort %.0f - %s', s, SimulatedSubjectID{s});
    subject_info(s).subject_id = s;
    subject_info(s).group_id = 'S';
    subject_info(s).data_class = 'Hormone';
    subject_info(s).data_type = 'Simulated Cortisol';
    subject_info(s).cond_1 = 'Sleep';
    subject_info(s).cond_1_start = 0;
    subject_info(s).cond_1_end = 480;
    subject_info(s).cond_1_datafile = simulatedDataFile;
    subject_info(s).cond_2 = 'Wake';
    subject_info(s).cond_2_start = 480;
    subject_info(s).cond_2_end = 1440;
    subject_info(s).cond_2_datafile = simulatedDataFile;
    subject_info(s).units = units;   
end

%----------------------------------------- Create hormone database variable
% Create hormone database variable
hormone_database.description = description;
hormone_database.subject_info = subject_info;
hormone_database.subject_data = subject_data;
hormone_database.T =  T;
hormone_database.delta_t = delta_t;
hormone_database.conditions = conditions;
hormone_database.groups = groups;
hormone_database.num_subjects = num_subjects;
hormone_database.units = units;


% Save cortisol database
save 'HAP Simulated Cortisol Database Demo.mat' hormone_database

end

