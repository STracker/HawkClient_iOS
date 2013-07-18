HawkClient iOS
==============

This project is an implementation of Hawk client for iOS. For more information visit [hueniverse/hawk](https://github.com/hueniverse/hawk).  
This client don't use the port number when generates the MAC because some hosts services use load balancing.  
It is also available in this project, the function for creating a nonce and the function for get the timestamp in seconds from UTC.
  
#### Installation
From [Cocoapods](http://cocoapods.org/?q=HawkClient).

#### Usage
With this client is possible to make a request with and without payload validation.  
Example without payload validation:  
<pre>
<code>
NSString *header = [HawkClient generateAuthorizationHeader:url method:method timestamp:timestamp nonce:nonce credentials:credentials ext:ext payload:ext payloadValidation:NO];
</code>
</pre>
  
Example with payload validation:   
<pre>
<code> 
NSString *header = [HawkClient generateAuthorizationHeader:url method:method timestamp:timestamp nonce:nonce credentials:credentials ext:ext payload:payload payloadValidation:YES];
</code>  
</pre>  

See unit tests project if you still in doubt.

#### Dependencies
- [Base64](https://github.com/ekscrypto/Base64)