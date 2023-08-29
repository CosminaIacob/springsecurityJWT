package com.easybytes.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.GenericGenerator;

import java.util.Set;

@Getter
@Setter
@Entity
public class Customer {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "native")
    @GenericGenerator(name = "native", strategy = "native")
    @Column(name = "customer_id")
    private int id;

    private String name;

    private String email;

    @Column(name = "mobile_number")
    private String mobileNumber;

    // we don't use @JsonIgnore here because we need the password at login/register inside the json request
    // with @JsonProperty we can define the access values as write only
    // always want to field in the request coming from UI to BE,
    // butI don't want to send the password details loaded from DB back to the UI
    @JsonProperty(access = JsonProperty.Access.WRITE_ONLY)
    private String pwd;

    private String role;

    @Column(name = "create_dt")
    private String createDt;

    // this field will not be sent inside the JSON response
    // don't want to share this sensitive information with the UI
    // only want to use this authorities information inside the BE app
    @JsonIgnore
    // A single customer can have multiple authorities
    // A single record of customer can be mapped to many records of authorities
    // For mappedBy we need to sue the same field name we have inside the Authority entity
    // FetchType.EAGER -> whenever it is trying to load the customer details,
    // to load the authorities details as well eagerly
    @OneToMany(mappedBy = "customer", fetch = FetchType.EAGER)
    private Set<Authority> authorities;
}
