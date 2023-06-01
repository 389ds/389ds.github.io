---
title: "HAProxy Connection Proxy Design"
---

# HAProxy Connection Proxy Design
----------------------------------------

{% include toc.md %}

This document describes the processing of an HAProxy header in an existing connection object. The code first checks if the HAProxy header in the connection has been read. If not, it sets the c_haproxyheader_read attribute to 1 indicating that the header has been read.
It's done this way as we want to read HAProxy header only once in worker thread for the same connection.

Additionally, the HAProxy header is only checked if nsslapd-haproxy-trusted-ip is configured, indicating that the connection comes from a trusted proxy server. If the connection doesn't come from a trusted server, or if the header is incorrect or incomplete, the connection is discarded and an error is logged.

Then we run haproxy_receive function which is designed to receive and parse HAProxy headers. The function supports both version 1 and version 2 of the HAProxy protocol. The parameters to this function are a file descriptor from which to read, a pointer to store the proxy connection status (proxied or not), and two pointers to PRNetAddr structures to store the source and destination address info from the HAProxy header.

The function may return: HAPROXY_HEADER_PARSED 0, HAPROXY_NOT_A_HEADER 1, HAPROXY_ERROR -1.

The code then proceeds to normalize the IP addresses from the connection and the HAProxy header. It checks the list of trusted IPs against the original client IP and the HAProxy header's destination IP. If a match is found, the code proceeds; if not, the connection is disconnected and an error is logged. As mentioned, we should deny any connection from unknown sources when dealt with HAProxy (to avoid IP spoofing).

Finally, if all's good, the connection details in the connection object are replaced with the new addresses from the header. 

# HAProxy Protocol Overview
----------

The parser supports two versions of the HAProxy protocol:

- Version 1 (text-based format)
- Version 2 (binary format)

Both versions are used to provide information about the client and server IP addresses and ports. The parser supports IPv4 and IPv6 addresses and TCP transport protocol.

The main functions of the parser are:

- Parse and validate the HAProxy protocol header
- Extract the client and server IP addresses and ports
- Convert and store the extracted IP addresses and ports in a standard format

# HAProxy Parser Design
--------

The parser consists of several functions that are responsible for different parts of the parsing process.

## haproxy_parse_v2_hdr
This function is responsible for parsing and validating the HAProxy protocol version 2 header. It takes the input string, checks if it's valid, and extracts the protocol version, command, and address family. It also calculates the header length and checks if it's within the allowed limits.

Once the input string is parsed and validated, the function assigns the extracted client and server IP addresses and ports to the PRNetAddr structures.

It calls the following helper functions to parse different parts of the version 1 header.

### haproxy_parse_v2_addr_v4
This function is responsible for parsing IPv4 addresses in version 2 of the protocol. It takes the input address and port, validates them, and assigns them to the PRNetAddr structure. It also prints the address in a human-readable format.

### haproxy_parse_v2_addr_v6
This function is responsible for parsing IPv6 addresses in version 2 of the protocol. It takes the input address and port, validates them, and assigns them to the PRNetAddr structure. It also prints the address in a human-readable format.

## haproxy_parse_v1_hdr
This function is responsible for parsing and validating the HAProxy protocol version 1 header. It takes the input string, checks if it's valid, and extracts the protocol, address family, client and server IP addresses, and client and server ports.

Once the input string is parsed and validated, the function assigns the extracted client and server IP addresses and ports to the PRNetAddr structures.

It calls the following helper functions to parse different parts of the version 1 header.

### haproxy_parse_v1_protocol
This function is responsible for parsing the protocol (TCP) in version 1 of the HAProxy protocol. It takes the input string and checks if it matches the expected protocol string.

### haproxy_parse_v1_fam
This function is responsible for parsing the address family (IPv4 or IPv6) in version 1 of the protocol. It takes the input string and checks if it matches the expected family string. If it does, it assigns the corresponding address family constant.

### haproxy_parse_v1_addr
This function is responsible for parsing IP addresses in version 1 of the protocol. It takes the input string and address family, validates the address, and assigns it to the PRNetAddr structure.

### haproxy_parse_v1_port
This function is responsible for parsing port numbers in version 1 of the protocol. It takes the input string, converts it to a port number, and assigns it to the PRNetAddr structure.

# Error Handling
The parser functions return error codes when an invalid input or an unsupported feature is encountered. The functions use slapi_log_err to log the error messages, which can be helpful for debugging.