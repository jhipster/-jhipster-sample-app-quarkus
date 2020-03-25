package com.mycompany.myapp.web.rest;

import com.mycompany.myapp.security.jwt.TokenProvider;
import com.mycompany.myapp.service.AuthenticationService;
import com.mycompany.myapp.web.rest.vm.LoginVM;
import io.quarkus.security.runtime.QuarkusSecurityIdentity;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.annotation.security.PermitAll;
import javax.enterprise.context.RequestScoped;
import javax.inject.Inject;
import javax.json.bind.annotation.JsonbProperty;
import javax.validation.Valid;
import javax.ws.rs.Consumes;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

/**
 * Controller to authenticate users.
 */
@Path("/api")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
@RequestScoped
public class UserJWTController {

    private final Logger log = LoggerFactory.getLogger(UserJWTController.class);

    final AuthenticationService authenticationService;

    final TokenProvider tokenProvider;

    @Inject
    public UserJWTController(AuthenticationService authenticationService, TokenProvider tokenProvider) {
        this.authenticationService = authenticationService;
        this.tokenProvider = tokenProvider;
    }

    @POST
    @Path("/authenticate")
    @PermitAll
    public Response authorize(@Valid LoginVM loginVM) {
        try {
            QuarkusSecurityIdentity identity = authenticationService.authenticate(loginVM.username, loginVM.password);
            boolean rememberMe = (loginVM.rememberMe == null) ? false : loginVM.rememberMe;
            String jwt = tokenProvider.createToken(identity, rememberMe);
            return Response.ok().entity(new JWTToken(jwt)).header("Authorization", "Bearer " + jwt).build();
        } catch (SecurityException e) {
            return Response.status(401).build();
        }
    }

    /**
     * Object to return as body in JWT Authentication.
     */
    public static class JWTToken {

        @JsonbProperty("id_token")
        public String idToken;

        JWTToken(String idToken) {
            this.idToken = idToken;
        }
    }
}
