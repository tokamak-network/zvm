"use strict";

var _script = _interopRequireDefault(require("../script.ts"));

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { "default": obj }; }

function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

var prompts = require('prompts');

prompts.override(require('yargs').argv); // const { readUser } = require('./script.ts')

_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee() {
  var response;
  return regeneratorRuntime.wrap(function _callee$(_context) {
    while (1) {
      switch (_context.prev = _context.next) {
        case 0:
          _context.next = 2;
          return prompts([{
            type: 'text',
            name: 'twitter',
            message: "What's your twitter handle?"
          }, {
            type: 'select',
            name: 'color',
            message: 'Pick colors',
            choices: [{
              title: 'Red',
              value: '#ff0000'
            }, {
              title: 'Green',
              value: '#00ff00'
            }, {
              title: 'Blue',
              value: '#0000ff'
            }]
          }]);

        case 2:
          response = _context.sent;
          console.log(_script["default"]);
          console.log(response);

        case 5:
        case "end":
          return _context.stop();
      }
    }
  }, _callee);
}))();