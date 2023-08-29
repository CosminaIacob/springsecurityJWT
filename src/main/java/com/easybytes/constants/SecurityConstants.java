package com.easybytes.constants;

public interface SecurityConstants {

    // this will be known only by the BE app
    // has to be super secure -> in PROD this should be injected at runtime during the deployment time
    // as an env variable using CI/CD tools like GitHub or Jenkins
    // or can be also configured as an env var inside the PROD server
    String JWT_KEY = "jxgEQeXHuPq8VdbyYFNkANdudQ53YUn4";
    String JWT_HEADER = "Authorization";
}
