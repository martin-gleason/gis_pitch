/* @preserve
* @esri/arcgis-rest-geocoder - v1.13.0 - Apache-2.0
* Copyright (c) 2017-2018 Esri, Inc.
* Tue Oct 09 2018 07:54:35 GMT-0700 (PDT)
*/
(function (global, factory) {
	typeof exports === 'object' && typeof module !== 'undefined' ? factory(exports, require('@esri/arcgis-rest-request')) :
	typeof define === 'function' && define.amd ? define(['exports', '@esri/arcgis-rest-request'], factory) :
	(factory((global.arcgisRest = global.arcgisRest || {}),global.arcgisRest));
}(this, (function (exports,arcgisRestRequest) { 'use strict';

/*! *****************************************************************************
Copyright (c) Microsoft Corporation. All rights reserved.
Licensed under the Apache License, Version 2.0 (the "License"); you may not use
this file except in compliance with the License. You may obtain a copy of the
License at http://www.apache.org/licenses/LICENSE-2.0

THIS CODE IS PROVIDED ON AN *AS IS* BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
KIND, EITHER EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION ANY IMPLIED
WARRANTIES OR CONDITIONS OF TITLE, FITNESS FOR A PARTICULAR PURPOSE,
MERCHANTABLITY OR NON-INFRINGEMENT.

See the Apache Version 2.0 License for specific language governing permissions
and limitations under the License.
***************************************************************************** */
/* global Reflect, Promise */



var __assign = Object.assign || function __assign(t) {
    for (var s, i = 1, n = arguments.length; i < n; i++) {
        s = arguments[i];
        for (var p in s) if (Object.prototype.hasOwnProperty.call(s, p)) t[p] = s[p];
    }
    return t;
};

/* Copyright (c) 2017 Environmental Systems Research Institute, Inc.
 * Apache-2.0 */
// https always
var worldGeocoder = "https://geocode.arcgis.com/arcgis/rest/services/World/GeocodeServer/";
/**
 * Used to fetch metadata from a geocoding service.
 *
 * ```js
 * import { getGeocoderServiceInfo } from '@esri/arcgis-rest-geocoder';
 *
 * getGeocoderServiceInfo()
 *   .then((response) => {
 *     response.serviceDescription; // => 'World Geocoder'
 *   });
 * ```
 *
 * @param requestOptions - Request options can contain a custom geocoding service to fetch metadata from.
 * @returns A Promise that will resolve with the data from the response.
 */
function getGeocodeService(requestOptions) {
    var url = (requestOptions && requestOptions.endpoint) || worldGeocoder;
    var options = __assign({ httpMethod: "GET", maxUrlLength: 2000 }, requestOptions);
    return arcgisRestRequest.request(url, options);
}
/**
 * Deprecated. Please use [`getGeocodeService()`](../getGeocodeService/) instead.
 *
 * @param requestOptions - Request options can contain a custom geocoding service to fetch metadata from.
 * @returns A Promise that will resolve with the data from the response.
 */
function serviceInfo(requestOptions) {
    arcgisRestRequest.warn("serviceInfo() will be deprecated in the next major release. please use getGeocoderServiceInfo() instead.");
    return getGeocodeService(requestOptions);
}

/* Copyright (c) 2017-2018 Environmental Systems Research Institute, Inc.
 * Apache-2.0 */
/**
 * Used to determine the [location](https://developers.arcgis.com/rest/geocode/api-reference/geocoding-find-address-candidates.htm)  of a single address or point of interest.
 *
 * ```js
 * import { geocode } from '@esri/arcgis-rest-geocoder';
 *
 * geocode("LAX")
 *   .then((response) => {
 *     response.candidates[0].location; // => { x: -118.409, y: 33.943, spatialReference: { wkid: 4326 }  }
 *   });
 *
 * geocode({
 *   params: {
 *     address: "1600 Pennsylvania Ave",
 *     postal: 20500,
 *     countryCode: "USA"
 *   }
 * })
 *   .then((response) => {
 *     response.candidates[0].location; // => { x: -77.036533, y: 38.898719, spatialReference: { wkid: 4326 } }
 *   });
 * ```
 *
 * @param address String representing the address or point of interest or RequestOptions to pass to the endpoint.
 * @returns A Promise that will resolve with address candidates for the request.
 */
function geocode(address) {
    var options = {
        endpoint: worldGeocoder,
        params: {}
    };
    if (typeof address === "string") {
        options.params.singleLine = address;
    }
    else {
        options.endpoint = address.endpoint || worldGeocoder;
        options = __assign({}, options, address);
    }
    // add spatialReference property to individual matches
    return arcgisRestRequest.request(options.endpoint + "findAddressCandidates", options).then(function (response) {
        var sr = response.spatialReference;
        response.candidates.forEach(function (candidate) {
            candidate.location.spatialReference = sr;
        });
        return response;
    });
}

/* Copyright (c) 2017-2018 Environmental Systems Research Institute, Inc.
 * Apache-2.0 */
/**
 * Used to return a placename [suggestion]((https://developers.arcgis.com/rest/geocode/api-reference/geocoding-suggest.htm) for a partial string.
 *
 * ```js
 * import { suggest } from '@esri/arcgis-rest-geocoder';
 *
 * suggest("Starb")
 *   .then((response) => {
 *     response.address.PlaceName; // => "Starbucks"
 *   });
 * ```
 *
 * @param requestOptions - Options for the request including authentication and other optional parameters.
 * @returns A Promise that will resolve with the data from the response.
 */
function suggest(partialText, requestOptions) {
    var options = __assign({ endpoint: worldGeocoder, params: {} }, requestOptions);
    // is this the most concise way to mixin these optional parameters?
    if (requestOptions && requestOptions.params) {
        options.params = requestOptions.params;
    }
    if (requestOptions && requestOptions.magicKey) {
        options.params.magicKey = requestOptions.magicKey;
    }
    options.params.text = partialText;
    return arcgisRestRequest.request(options.endpoint + "suggest", options);
}

/* Copyright (c) 2017-2018 Environmental Systems Research Institute, Inc.
 * Apache-2.0 */
function isLocationArray(coords) {
    return coords.length === 2;
}
function isLocation(coords) {
    return (coords.latitude !== undefined ||
        coords.lat !== undefined);
}
/**
 * Used to determine the address of a [location](https://developers.arcgis.com/rest/geocode/api-reference/geocoding-reverse-geocode.htm).
 *
 * ```js
 * import { reverseGeocode } from '@esri/arcgis-rest-geocoder';
 *
 * // long, lat
 * reverseGeocode([-118.409,33.943 ])
 *   .then((response) => {
 *     response.address.PlaceName; // => "LA Airport"
 *   });
 *
 * // or
 * reverseGeocode({ long: -118.409, lat: 33.943 })
 * reverseGeocode({ latitude: 33.943, latitude: -118.409 })
 * reverseGeocode({ x: -118.409, y: 33.9425 }) // wgs84 is assumed
 * reverseGeocode({ x: -13181226, y: 4021085, spatialReference: { wkid: 3857 })
 * ```
 *
 * @param coordinates - the location you'd like to associate an address with.
 * @param requestOptions - Additional options for the request including authentication.
 * @returns A Promise that will resolve with the data from the response.
 */
function reverseGeocode(coords, requestOptions) {
    var options = __assign({ endpoint: worldGeocoder, params: {} }, requestOptions);
    if (isLocationArray(coords)) {
        options.params.location = coords.join();
    }
    else if (isLocation(coords)) {
        if (coords.lat) {
            options.params.location = coords.long + "," + coords.lat;
        }
        if (coords.latitude) {
            options.params.location = coords.longitude + "," + coords.latitude;
        }
    }
    else {
        // if input is a point, we can pass it straight through, with or without a spatial reference
        options.params.location = coords;
    }
    return arcgisRestRequest.request(options.endpoint + "reverseGeocode", options);
}

/* Copyright (c) 2017-2018 Environmental Systems Research Institute, Inc.
 * Apache-2.0 */
/**
 * Used to geocode a [batch](https://developers.arcgis.com/rest/geocode/api-reference/geocoding-geocode-addresses.htm) of addresses.
 *
 * ```js
 * import { bulkGeocode } from '@esri/arcgis-rest-geocoder';
 * import { ApplicationSession } from '@esri/arcgis-rest-auth';
 *
 * const addresses = [
 *   { "OBJECTID": 1, "SingleLine": "380 New York Street 92373" },
 *   { "OBJECTID": 2, "SingleLine": "1 World Way Los Angeles 90045" }
 * ];
 *
 * bulkGeocode({ addresses, authentication: session })
 *   .then((response) => {
 *     response.locations[0].location; // => { x: -117, y: 34, spatialReference: { wkid: 4326 } }
 *   });
 * ```
 *
 * @param requestOptions - Request options to pass to the geocoder, including an array of addresses and authentication session.
 * @returns A Promise that will resolve with the data from the response.
 */
function bulkGeocode(requestOptions // must POST
) {
    var options = __assign({ endpoint: worldGeocoder, params: {
            forStorage: true,
            addresses: { records: [] }
        } }, requestOptions);
    requestOptions.addresses.forEach(function (address) {
        options.params.addresses.records.push({ attributes: address });
    });
    // the SAS service doesnt support anonymous requests
    if (!requestOptions.authentication && options.endpoint === worldGeocoder) {
        return Promise.reject("bulk geocoding using the ArcGIS service requires authentication");
    }
    return arcgisRestRequest.request(options.endpoint + "geocodeAddresses", options).then(function (response) {
        var sr = response.spatialReference;
        response.locations.forEach(function (address) {
            address.location.spatialReference = sr;
        });
        return response;
    });
}

/* Copyright (c) 2018 Environmental Systems Research Institute, Inc.
 * Apache-2.0 */

exports.geocode = geocode;
exports.suggest = suggest;
exports.reverseGeocode = reverseGeocode;
exports.bulkGeocode = bulkGeocode;
exports.worldGeocoder = worldGeocoder;
exports.getGeocodeService = getGeocodeService;
exports.serviceInfo = serviceInfo;

Object.defineProperty(exports, '__esModule', { value: true });

})));
//# sourceMappingURL=geocoder.umd.js.map