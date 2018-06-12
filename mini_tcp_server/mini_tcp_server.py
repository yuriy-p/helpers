import socket
import sys
import subprocess
import time

# Create a TCP/IP socket
sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

if len(sys.argv) < 4:
	print 'Usage: {} <SERVER_BIND_IP> <SERVER_BIND_PORT> <CLIENT_IP>'.format(sys.argv[0])
	quit()
# Bind the socket to the address given on the command line
server_address = sys.argv[1]
server_port = sys.argv[2]
client_address2check = sys.argv[3]
server_address_port = (server_address, int(server_port))
print >>sys.stderr, 'starting up on %s port %s' % server_address_port
sock.bind(server_address_port)
sock.listen(1)

while True:
    print >>sys.stderr, 'waiting for a connection'
    connection, client_address = sock.accept()
    try:
        print >>sys.stderr, 'client connected:', client_address

        if client_address[0] != client_address2check:
        	print 'client connection only from {} is expected'.format(client_address2check)
        	continue

        inputbuffer = ''
        input_begin = time.time()
        while True:
            data = connection.recv(32) #max receive buffer size
            print >>sys.stderr, 'received "%s"' % data
            if data:
                if time.time() - input_begin > 10: #max time to wait for command sequence
                    inputbuffer = ''
                
                input_begin = time.time()
                inputbuffer += data
                if 'myreboot' in inputbuffer: #command
#                    subprocess.call("shutdown -r -t 0", shell=True)
                    subprocess.call("dir c:", shell=True)
                    break
                if len(inputbuffer) > 16: #max command length
                    print inputbuffer
                    break
            else:
                break
    finally:
        connection.close()
