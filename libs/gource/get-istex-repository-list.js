#!/usr/bin/env node
/**
 * Get the istex repository list for the github RESTful API
 * (need to run "npm install" before use)
 */

var request = require('superagent');

request
  .get('http://vpgithub.intra.inist.fr/api/v3/orgs/istex/repos')
  .set('Authorization', 'token b599a88cb9e1c67a40284517cd6860cf18ea7c4c')
  .end(function (res){
    if (res.ok) {
      res.body.forEach(function (repository, idx) {
        console.log(repository.name);
      });
   } else {
     console.error('Oh no! error ' + res.text);
     process.exit(1);
   }
 });
