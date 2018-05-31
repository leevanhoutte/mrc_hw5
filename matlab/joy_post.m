% Create a bag file object with the file name
bag = rosbag('~/mrc_hw5_data/joy1.bag')
   
% Display a list of the topics and message types in the bag file
bag.AvailableTopics
   
% Since the messages on topic /odom are of type Odometry,
% let's see some of the attributes of the Odometry
% This helps determine the syntax for extracting data
msg_odom = rosmessage('nav_msgs/Odometry')
showdetails(msg_odom)
   
% Get just the topic we are interested in
bagselect = select(bag,'Topic','/odom');
   
% Create a time series object based on the fields of the turtlesim/Pose
% message we are interested in
ts = timeseries(bagselect,'Pose.Pose.Position.X','Pose.Pose.Position.Y',...
    'Twist.Twist.Linear.X','Twist.Twist.Angular.Z',...
    'Pose.Pose.Orientation.W','Pose.Pose.Orientation.X',...
    'Pose.Pose.Orientation.Y','Pose.Pose.Orientation.Z');
% The time vector in the timeseries (ts.Time) is "Unix Time"
% which is a bit cumbersome.  Create a time vector that is relative
% to the start of the log file
tt = ts.Time-ts.Time(1);

%% Plot the Time vs. Forward Velocity
figure(1);
clf();
plot(tt,ts.Data(:,3))
xlabel('Time [seconds]')
ylabel('Forward Velocity [m/s]')
title('Velocity vs. Time')

%% Plot the X vs. Y position
figure(2);
clf();
plot(ts.Data(:,1),ts.Data(:,2))
xlabel('X [m ]')
ylabel('Y [m]')
title('X vs. Y')
%% Plot the Yaw vs. Time
figure(3);
clf();
plot(tt,ts.Data(:,4))
xlabel('Time [seconds]')
ylabel('Yaw [deg]')
title('Yaw vs. Time')

%% Develop Quiver Plot
figure(4)
x=ts.Data(:,1);
y=ts.Data(:,2);
vel=ts.Data(:,3);
th=ts.Data(:,4);
u = vel.*cos(th);
v = vel.*sin(th);
ii = 1:10:length(x);  % Decimate the data so that it plot only every Nth point.
quiver(x(ii),y(ii),u(ii),v(ii))
title('Quiver plot')