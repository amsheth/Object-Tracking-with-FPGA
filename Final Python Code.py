################################################################################################# FUNCTIONS FOR OUR USE
# Function to swap every 4 bytes in a buffer
def swap(buf):
    buf_rearranged = bytearray(len(buf))
    for i in range(0, len(buf), 4):
        chunk = buf[i:i + 4]  # Extract 4-byte chunk
        chunk[:] = chunk[::-1]  # Reverse the entire 4-byte chunk
        buf_rearranged[i:i + 4] = chunk  # Store the modified chunk in the rearranged array
    return buf_rearranged

# Function to swap upper and lower byte of a 16 bit value passed in
def bits(value):
    # Mask to extract upper 8 bits (most significant bits)
    upper_mask = (value & 0xFF00) >> 8
    # Mask to extract lower 8 bits (least significant bits)
    lower_mask = (value & 0x00FF) << 8
    # Combine the swapped bits
    swapped_value = upper_mask | lower_mask
    if swapped_value & 0x8000:
       signed_value = -((swapped_value ^ 0xFFFF) + 1)
    else:
       signed_value = swapped_value
    return signed_value

################################################################################################# IMPORTS
import numpy as np
import pyvisa as visa # You should pip install pyvisa and restart the kernel.
import numpy as np
import matplotlib as mpl
import matplotlib.pyplot as plt
mpl.style.use('ggplot')

import numpy as np
from PIL import Image
import cv2
import time
import threading

# import various libraries necessary to run your Python code
import sys,os # system related library
ok_sdk_loc = "C:\\Program Files\\Opal Kelly\\FrontPanelUSB\\API\\Python\\x64"
ok_dll_loc = "C:\\Program Files\\Opal Kelly\\FrontPanelUSB\\API\\lib\\x64"
sys.path.append(ok_sdk_loc) # add the path of the OK library
os.add_dll_directory(ok_dll_loc)

import ok # OpalKelly library
# Define FrontPanel device variable, open USB communication and
# load the bit file in the FPGA
dev = ok.okCFrontPanel() # define a device for FrontPanel communication
SerialStatus=dev.OpenBySerial("") # open USB communication with the OK board
# We will NOT load the bit file because it will be loaded using JTAG interface from Vivado
# Check if FrontPanel is initialized correctly and if the bit file is loaded.
# Otherwise terminate the program
print("----------------------------------------------------")

################################################################################################# FRONTPANEL INITIALIZATION
if SerialStatus == 0:
 print ("FrontPanel host interface was successfully initialized.")

else:
 print ("FrontPanel host interface not detected. The error code number is:" + str(int(SerialStatus)))
 print("Exiting the program.")
 sys.exit ()

################################################################################################# INSTRUMENT INITIALIZATION
device_manager = visa.ResourceManager()
devices = device_manager.list_resources()
number_of_device = len(devices)

# device initializations
power_supply_id = -1
waveform_generator_id = -1
digital_multimeter_id = -1
oscilloscope_id = -1

# assumes only the DC power supply is connected
for i in range (0, number_of_device):

# check that it is actually the power supply
    try:
        device_temp = device_manager.open_resource(devices[i])
        print("Instrument connect on USB port number [" + str(i) + "] is " + device_temp.query("*IDN?"))
        if (device_temp.query("*IDN?") == 'HEWLETT-PACKARD,E3631A,0,3.2-6.0-2.0\r\n'):
            power_supply_id = i        
        if (device_temp.query("*IDN?") == 'HEWLETT-PACKARD,E3631A,0,3.0-6.0-2.0\r\n'):
            power_supply_id = i
        if (device_temp.query("*IDN?") == 'Agilent Technologies,33511B,MY52301259,3.03-1.19-2.00-52-00\n'):
            waveform_generator_id = i
        if (device_temp.query("*IDN?") == 'Agilent Technologies,34461A,MY53207926,A.01.10-02.25-01.10-00.35-01-01\n'):
            digital_multimeter_id = i
        if (device_temp.query("*IDN?") == 'Keysight Technologies,34461A,MY53213280,A.02.08-02.37-02.08-00.49-01-01\n'):
            digital_multimeter_id = i            
        if (device_temp.query("*IDN?") == 'KEYSIGHT TECHNOLOGIES,MSO-X 3024T,MY54440323,07.50.2021102830\n'):
            oscilloscope_id = i                        
        device_temp.close()
    except:
        print("Instrument on USB port number [" + str(i) + "] cannot be connected. The instrument might be powered of or you are trying to connect to a mouse or keyboard.\n")

# sit here if power supply wasn't initialized correctly   
while (power_supply_id == -1): 
    print("Something is wrong!")

####################################################################################### POWER SUPPLY READY FOR SUPPLYING PMOD    
print("Power supply is connected to the PC.")
power_supply = device_manager.open_resource(devices[power_supply_id])
print(power_supply.write("OUTPUT ON")) # power supply output is turned on
power_supply.write("APPLy P6V, %0.2f, 1" % 4) # DO NOT FORGET TO CLOSE THIS LATER

# pause 50ms to let things settle
time.sleep(0.5)

measured_voltage = power_supply.query("MEASure:VOLTage:DC? P6V") # confirm voltage value via SCPI
    
####################################################################################### SPI INITIALIZATION AND CONFIRMATION FOR CAMERA SENSOR

# dictionary for spi values and addresses
dic ={1:232,2:1,43:11,55:120,57:3, 58:44,59:240,60:10,68:1,69:9,80:2,83:187,97:240,98:10,100:112,101:98,102:34,103:64,106:94,107:110,108:91,109:82,110:80,117:91}

# initializing spi registers
for i in dic:
    dev.SetWireInValue(0x01,dic[i]) 
    dev.UpdateWireIns()
    dev.SetWireInValue(0x02,i) 
    dev.UpdateWireIns()

    
    SPI_Control = 3 # send a "go" signal to the SPI FSM
    dev.SetWireInValue(0x00, SPI_Control)
    dev.UpdateWireIns() # Update the WireIns

    # time.sleep(0.01)

    SPI_Control = 0 # send a "stop" signal to the FSM
    dev.SetWireInValue(0x00, SPI_Control)
    dev.UpdateWireIns() # Update the WireIns
    # print ("writing value into reg:",i,"is",dic[i])

# reading spi registers to confirm values
for i in range (128):
    dev.SetWireInValue(0x02,i) 
    dev.UpdateWireIns()
    SPI_Control = 1 # send a "go" signal to the FSM
    dev.SetWireInValue(0x00, SPI_Control)
    dev.UpdateWireIns() # Update the WireIns

    # time.sleep(0.01)

    SPI_Control = 0 # send a "stop" signal to the FSM
    dev.SetWireInValue(0x00, SPI_Control)
    dev.UpdateWireOuts()
    z = dev.GetWireOutValue(0x20)
    print ("the value from reg:",i,"is",z)

####################################################################################### I2C/MOTOR PREPARATION SECTION
motor_pulses = 100 # 10
motor_control = 0 # 9

i2c_control = 0 # 4

i2c_acc_slave_address = 0x32 # 5
i2c_acc_ctrl_address = 0b00100000 # 6
i2c_acc_ctrl_data = 0b01010111 # 7
i2c_acc_some_value = 0b10101000 # 8

i2c_mag_slave_address = 0x3C # 5
i2c_mag_ctrl_address = 0x02 # 6
i2c_mag_ctrl_data = 0x00 # 7
i2c_mag_some_value = 0b10000011 # 8

xyz_acc = []
xyz_mag = []

blah = np.arange(0, 100, 10)

for pulsenum in blah:

    dev.SetWireInValue(0x10, int(pulsenum)) # set 10 pulses for this voltage
    dev.UpdateWireIns()
    
    # setting addresses for acceleration data collection
    dev.SetWireInValue(0x05,i2c_acc_slave_address) # slave address
    dev.UpdateWireIns()
    dev.SetWireInValue(0x06,i2c_acc_ctrl_address) # control register address
    dev.UpdateWireIns()
    dev.SetWireInValue(0x07,i2c_acc_ctrl_data) # control register data
    dev.UpdateWireIns()
    dev.SetWireInValue(0x08,i2c_acc_some_value) # x data with top bit set as 1 for auto increment
    dev.UpdateWireIns()
    
    # dev.SetWireInValue(0x01,0x3C) # slave address
    # dev.UpdateWireIns()
    # dev.SetWireInValue(0x02,0x02) # control register address
    # dev.UpdateWireIns()
    # dev.SetWireInValue(0x03,0x00) # control register data
    # dev.UpdateWireIns()
    
    dev.SetWireInValue(0x09, 3) # start motor controller
    dev.UpdateWireIns()
    
    for j in range (0, 5): # take 5 acceleration readings for each pulse iteration
    
        # time.sleep(0.5)
        
        i2c_control = 1 # send a "go" signal to the FSM
        dev.SetWireInValue(0x04, i2c_control)
        dev.UpdateWireIns()  # Update the WireIns
            
        time.sleep(0.1)
            
        PC_Control = 0 # send a "stop" signal to the FSM
        dev.SetWireInValue(0x04, i2c_control)
        dev.UpdateWireIns()  # Update the WireIns
            
        dev.UpdateWireOuts()

        x = dev.GetWireOutValue(0x21)
        
        dev.UpdateWireOuts()
        y = dev.GetWireOutValue(0x22)  
        
        dev.UpdateWireOuts()
        z = dev.GetWireOutValue(0x23)

        xyz_acc.append([bits(x)/16200.5333333*9.8, bits(y)/16142.93333333*9.8, bits(z)/16200.5333333*9.8])
    
    dev.SetWireInValue(0x09, 0) # motor controller RESET FOR NEXT ITERATION
    # use trigger in to indicate that pulses have been done?
    dev.UpdateWireIns()    
    
############################################################################################## PRINT RESULTS AND CLOSE
for val in xyz_acc:
    print(val)

print(power_supply.write("OUTPUT OFF"))
power_supply.close()
print("closed")

# try:
#     while True:
#         # Your loop code goes here
#         print("Looping...")

# except KeyboardInterrupt:
#     print("\nLoop interrupted by user. Exiting.")

####################################################################################### OPENCV SECTION

# width, height = 648, 484  
# buf = bytearray(width* height);
# buf_rearranged = bytearray(len(buf));

# dev.ActivateTriggerIn(0x40, 0); #Reset FIFOs and counter

# dev.ReadFromBlockPipeOut(0xa0, 32, buf);  # Read data from BT PipeOut

# for i in range(0, len(buf), 4):
#     chunk = buf[i:i + 4]  # Extract 4-byte chunk
#     chunk[:] = chunk[::-1]  # Reverse the entire 4-byte chunk
#     buf_rearranged[i:i + 4] = chunk  # Store the modified chunk in the rearranged array

# # Creating the image from the byte array (directly with PIL library, no need for making a 2D array)
# img = Image.frombytes('L', (width, height), bytes(buf_rearranged))
# img.show()  # Display the image

# frame = np.reshape(buf_rearranged,(height,width))
# # parameters_shitomasi = dict(maxCorners=100, qualityLevel=0.3, minDistance=7)
# # edges = cv2.goodFeaturesToTrack(prev_frame, mask = None, **parameters_shitomasi)
# # canvas = np.zeros_like(buf_rearranged)
# # create random colours for visualization for all 100 max corners for RGB channels
# # colours = np.random.randint(0, 255, (100, 3))
# # parameter_lucas_kanade = dict(winSize=(15, 15), maxLevel=2, criteria=(cv2.TERM_CRITERIA_EPS | cv2.TERM_CRITERIA_COUNT, 10, 0.03))

# tracker = cv2.TrackerCSRT_create()
# bbox = (287, 23, 86, 320)
# # Uncomment the line below to select a different bounding box
# bbox = cv2.selectROI(frame, False)
# # Initialize tracker with first frame and bounding box
# ok = tracker.init(frame, bbox)
# start_time = time.time()
# frame_count = 0
# prev_p1=(0,0)
# # cv2.namedWindow('Video', cv2.WINDOW_NORMAL)
# while True:
#     dev.ActivateTriggerIn(0x40, 0); #Reset FIFOs and counter
#     dev.ReadFromBlockPipeOut(0xa0, 32, buf);  # Read data from BT PipeOut
#     image = np.frombuffer(buf,dtype=np.uint8)
#     reshaped_array = image.reshape(int(len(buf)/4), 4)
#     reversed_array = np.flip(reshaped_array, axis=1)
#     result_array = reversed_array.flatten()
#     frame=np.reshape(result_array, (height,width))
#     frame_count += 1
#     elapsed_time = time.time() - start_time
#     fps = frame_count / elapsed_time

#     # timer = cv2.getTickCount()

#     # Update tracker
#     ok, bbox = tracker.update(frame)

#     # Draw bounding box
#     if ok:
#         # Tracking success
#         p1 = (int(bbox[0]), int(bbox[1]))
#         p2 = (int(bbox[0] + bbox[2]), int(bbox[1] + bbox[3]))
#         cv2.rectangle(frame, p1, p2, (255,0,0), 2, 1)
#     else :
#         # Tracking failure
#         cv2.putText(frame, "Tracking failure detected", (20,80), cv2.FONT_HERSHEY_SIMPLEX, 0.5,(0,0,255),1)

#     # Display tracker type on frame
#     # cv2.putText(frame, 'CSRT Tracker', (10,20), cv2.FONT_HERSHEY_SIMPLEX, 0.3, (50,170,50),1);

#     # Display FPS on frame
#     cv2.putText(frame, "FPS : " + str(int(fps)), (10,50), cv2.FONT_HERSHEY_SIMPLEX, 0.3, (50,170,50), 1);    
#     cv2.putText(frame, "X : " + str(int(240-p1[1])), (10,70), cv2.FONT_HERSHEY_SIMPLEX, 0.3, (50,170,50), 1);
#     cv2.putText(frame, "Y : " + str(int(320-p1[0])), (10,90), cv2.FONT_HERSHEY_SIMPLEX, 0.3, (50,170,50), 1);

#     # Display result
#     cv2.imshow("Tracking", frame)
#     prev_p1=p1

#     # edges = cv2.goodFeaturesToTrack(frame, mask = None, **parameters_shitomasi)
#     # update_edges, status, errors = cv2.calcOpticalFlowPyrLK(prev_frame, frame, edges, None, **parameter_lucas_kanade)
#     # new_edges = update_edges[status == 1]
#     # # to calculate directional flow we need to compare with previous position
#     # old_edges = edges[status == 1]
#     # for i, (new, old) in enumerate(zip(new_edges, old_edges)):
#     #    a, b = new.ravel()
#     #    c, d = old.ravel()

#     #    # draw line between old and new corner point with random colour
#     #    mask = cv2.line(canvas, (int(a), int(b)), (int(c), int(d)), colours[i].tolist(), 2)
#     #    mask=np.reshape(mask, (height,width))
#     #    # draw circle around new position
#     #    frame = cv2.circle(frame, (int(a), int(b)), 5, colours[i].tolist(), -1)
#     # result = cv2.add(frame, mask)
#     # cv2.putText(frame, f"FPS: {fps:.2f}", (10, 15), cv2.FONT_HERSHEY_SIMPLEX, 0.3, (0, 255, 0),1)
#     # cv2.imshow('Optical Flow (sparse)', result)
#     # prev_frame = frame.copy()
#     # # update to new edges before restarting the loop
#     # edges = new_edges.reshape(-1, 1, 2)

#     if cv2.waitKey(1) & 0xFF == ord('q'):
#         break

# cv2.destroyAllWindows()

dev.Close