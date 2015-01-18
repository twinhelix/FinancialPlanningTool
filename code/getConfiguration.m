function [ configs ] = getConfiguration( name )
all_configs    = xml2struct('configurations.xml');
no_of_entries  = size(all_configs.Persons.Entry,2);

configs = NaN;

for i = 1:no_of_entries
    if strcmp(all_configs.Persons.Entry{i}.Name.Text, name)
       configs =  all_configs.Persons.Entry{i};
    end
end
end

