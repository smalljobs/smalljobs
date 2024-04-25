(function (global, factory) {
	typeof exports === 'object' && typeof module !== 'undefined' ? module.exports = factory() :
	typeof define === 'function' && define.amd ? define(factory) :
	(global = typeof globalThis !== 'undefined' ? globalThis : global || self, global.rcRealTimeAPI = factory());
})(this, (function () { 'use strict';

	var commonjsGlobal = typeof globalThis !== 'undefined' ? globalThis : typeof window !== 'undefined' ? window : typeof global !== 'undefined' ? global : typeof self !== 'undefined' ? self : {};

	function getAugmentedNamespace(n) {
	  if (n.__esModule) return n;
	  var f = n.default;
		if (typeof f == "function") {
			var a = function a () {
				if (this instanceof a) {
	        return Reflect.construct(f, arguments, this.constructor);
				}
				return f.apply(this, arguments);
			};
			a.prototype = f.prototype;
	  } else a = {};
	  Object.defineProperty(a, '__esModule', {value: true});
		Object.keys(n).forEach(function (k) {
			var d = Object.getOwnPropertyDescriptor(n, k);
			Object.defineProperty(a, k, d.get ? d : {
				enumerable: true,
				get: function () {
					return n[k];
				}
			});
		});
		return a;
	}

	var lib = {};

	var RealTimeAPI$2 = {};

	/*! *****************************************************************************
	Copyright (c) Microsoft Corporation.

	Permission to use, copy, modify, and/or distribute this software for any
	purpose with or without fee is hereby granted.

	THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
	REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY
	AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
	INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
	LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
	OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
	PERFORMANCE OF THIS SOFTWARE.
	***************************************************************************** */
	/* global Reflect, Promise */

	var extendStatics = function(d, b) {
	    extendStatics = Object.setPrototypeOf ||
	        ({ __proto__: [] } instanceof Array && function (d, b) { d.__proto__ = b; }) ||
	        function (d, b) { for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p]; };
	    return extendStatics(d, b);
	};

	function __extends(d, b) {
	    extendStatics(d, b);
	    function __() { this.constructor = d; }
	    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
	}

	var __assign = function() {
	    __assign = Object.assign || function __assign(t) {
	        for (var s, i = 1, n = arguments.length; i < n; i++) {
	            s = arguments[i];
	            for (var p in s) if (Object.prototype.hasOwnProperty.call(s, p)) t[p] = s[p];
	        }
	        return t;
	    };
	    return __assign.apply(this, arguments);
	};

	/** PURE_IMPORTS_START  PURE_IMPORTS_END */
	function isFunction(x) {
	    return typeof x === 'function';
	}

	/** PURE_IMPORTS_START  PURE_IMPORTS_END */
	var _enable_super_gross_mode_that_will_cause_bad_things = false;
	var config = {
	    Promise: undefined,
	    set useDeprecatedSynchronousErrorHandling(value) {
	        if (value) {
	            var error = /*@__PURE__*/ new Error();
	            /*@__PURE__*/ console.warn('DEPRECATED! RxJS was set to use deprecated synchronous error handling behavior by code at: \n' + error.stack);
	        }
	        _enable_super_gross_mode_that_will_cause_bad_things = value;
	    },
	    get useDeprecatedSynchronousErrorHandling() {
	        return _enable_super_gross_mode_that_will_cause_bad_things;
	    },
	};

	/** PURE_IMPORTS_START  PURE_IMPORTS_END */
	function hostReportError(err) {
	    setTimeout(function () { throw err; }, 0);
	}

	/** PURE_IMPORTS_START _config,_util_hostReportError PURE_IMPORTS_END */
	var empty$1 = {
	    closed: true,
	    next: function (value) { },
	    error: function (err) {
	        if (config.useDeprecatedSynchronousErrorHandling) {
	            throw err;
	        }
	        else {
	            hostReportError(err);
	        }
	    },
	    complete: function () { }
	};

	/** PURE_IMPORTS_START  PURE_IMPORTS_END */
	var isArray = /*@__PURE__*/ (function () { return Array.isArray || (function (x) { return x && typeof x.length === 'number'; }); })();

	/** PURE_IMPORTS_START  PURE_IMPORTS_END */
	function isObject(x) {
	    return x !== null && typeof x === 'object';
	}

	/** PURE_IMPORTS_START  PURE_IMPORTS_END */
	var UnsubscriptionErrorImpl = /*@__PURE__*/ (function () {
	    function UnsubscriptionErrorImpl(errors) {
	        Error.call(this);
	        this.message = errors ?
	            errors.length + " errors occurred during unsubscription:\n" + errors.map(function (err, i) { return i + 1 + ") " + err.toString(); }).join('\n  ') : '';
	        this.name = 'UnsubscriptionError';
	        this.errors = errors;
	        return this;
	    }
	    UnsubscriptionErrorImpl.prototype = /*@__PURE__*/ Object.create(Error.prototype);
	    return UnsubscriptionErrorImpl;
	})();
	var UnsubscriptionError = UnsubscriptionErrorImpl;

	/** PURE_IMPORTS_START _util_isArray,_util_isObject,_util_isFunction,_util_UnsubscriptionError PURE_IMPORTS_END */
	var Subscription = /*@__PURE__*/ (function () {
	    function Subscription(unsubscribe) {
	        this.closed = false;
	        this._parentOrParents = null;
	        this._subscriptions = null;
	        if (unsubscribe) {
	            this._ctorUnsubscribe = true;
	            this._unsubscribe = unsubscribe;
	        }
	    }
	    Subscription.prototype.unsubscribe = function () {
	        var errors;
	        if (this.closed) {
	            return;
	        }
	        var _a = this, _parentOrParents = _a._parentOrParents, _ctorUnsubscribe = _a._ctorUnsubscribe, _unsubscribe = _a._unsubscribe, _subscriptions = _a._subscriptions;
	        this.closed = true;
	        this._parentOrParents = null;
	        this._subscriptions = null;
	        if (_parentOrParents instanceof Subscription) {
	            _parentOrParents.remove(this);
	        }
	        else if (_parentOrParents !== null) {
	            for (var index = 0; index < _parentOrParents.length; ++index) {
	                var parent_1 = _parentOrParents[index];
	                parent_1.remove(this);
	            }
	        }
	        if (isFunction(_unsubscribe)) {
	            if (_ctorUnsubscribe) {
	                this._unsubscribe = undefined;
	            }
	            try {
	                _unsubscribe.call(this);
	            }
	            catch (e) {
	                errors = e instanceof UnsubscriptionError ? flattenUnsubscriptionErrors(e.errors) : [e];
	            }
	        }
	        if (isArray(_subscriptions)) {
	            var index = -1;
	            var len = _subscriptions.length;
	            while (++index < len) {
	                var sub = _subscriptions[index];
	                if (isObject(sub)) {
	                    try {
	                        sub.unsubscribe();
	                    }
	                    catch (e) {
	                        errors = errors || [];
	                        if (e instanceof UnsubscriptionError) {
	                            errors = errors.concat(flattenUnsubscriptionErrors(e.errors));
	                        }
	                        else {
	                            errors.push(e);
	                        }
	                    }
	                }
	            }
	        }
	        if (errors) {
	            throw new UnsubscriptionError(errors);
	        }
	    };
	    Subscription.prototype.add = function (teardown) {
	        var subscription = teardown;
	        if (!teardown) {
	            return Subscription.EMPTY;
	        }
	        switch (typeof teardown) {
	            case 'function':
	                subscription = new Subscription(teardown);
	            case 'object':
	                if (subscription === this || subscription.closed || typeof subscription.unsubscribe !== 'function') {
	                    return subscription;
	                }
	                else if (this.closed) {
	                    subscription.unsubscribe();
	                    return subscription;
	                }
	                else if (!(subscription instanceof Subscription)) {
	                    var tmp = subscription;
	                    subscription = new Subscription();
	                    subscription._subscriptions = [tmp];
	                }
	                break;
	            default: {
	                throw new Error('unrecognized teardown ' + teardown + ' added to Subscription.');
	            }
	        }
	        var _parentOrParents = subscription._parentOrParents;
	        if (_parentOrParents === null) {
	            subscription._parentOrParents = this;
	        }
	        else if (_parentOrParents instanceof Subscription) {
	            if (_parentOrParents === this) {
	                return subscription;
	            }
	            subscription._parentOrParents = [_parentOrParents, this];
	        }
	        else if (_parentOrParents.indexOf(this) === -1) {
	            _parentOrParents.push(this);
	        }
	        else {
	            return subscription;
	        }
	        var subscriptions = this._subscriptions;
	        if (subscriptions === null) {
	            this._subscriptions = [subscription];
	        }
	        else {
	            subscriptions.push(subscription);
	        }
	        return subscription;
	    };
	    Subscription.prototype.remove = function (subscription) {
	        var subscriptions = this._subscriptions;
	        if (subscriptions) {
	            var subscriptionIndex = subscriptions.indexOf(subscription);
	            if (subscriptionIndex !== -1) {
	                subscriptions.splice(subscriptionIndex, 1);
	            }
	        }
	    };
	    Subscription.EMPTY = (function (empty) {
	        empty.closed = true;
	        return empty;
	    }(new Subscription()));
	    return Subscription;
	}());
	function flattenUnsubscriptionErrors(errors) {
	    return errors.reduce(function (errs, err) { return errs.concat((err instanceof UnsubscriptionError) ? err.errors : err); }, []);
	}

	/** PURE_IMPORTS_START  PURE_IMPORTS_END */
	var rxSubscriber = /*@__PURE__*/ (function () {
	    return typeof Symbol === 'function'
	        ? /*@__PURE__*/ Symbol('rxSubscriber')
	        : '@@rxSubscriber_' + /*@__PURE__*/ Math.random();
	})();

	/** PURE_IMPORTS_START tslib,_util_isFunction,_Observer,_Subscription,_internal_symbol_rxSubscriber,_config,_util_hostReportError PURE_IMPORTS_END */
	var Subscriber = /*@__PURE__*/ (function (_super) {
	    __extends(Subscriber, _super);
	    function Subscriber(destinationOrNext, error, complete) {
	        var _this = _super.call(this) || this;
	        _this.syncErrorValue = null;
	        _this.syncErrorThrown = false;
	        _this.syncErrorThrowable = false;
	        _this.isStopped = false;
	        switch (arguments.length) {
	            case 0:
	                _this.destination = empty$1;
	                break;
	            case 1:
	                if (!destinationOrNext) {
	                    _this.destination = empty$1;
	                    break;
	                }
	                if (typeof destinationOrNext === 'object') {
	                    if (destinationOrNext instanceof Subscriber) {
	                        _this.syncErrorThrowable = destinationOrNext.syncErrorThrowable;
	                        _this.destination = destinationOrNext;
	                        destinationOrNext.add(_this);
	                    }
	                    else {
	                        _this.syncErrorThrowable = true;
	                        _this.destination = new SafeSubscriber(_this, destinationOrNext);
	                    }
	                    break;
	                }
	            default:
	                _this.syncErrorThrowable = true;
	                _this.destination = new SafeSubscriber(_this, destinationOrNext, error, complete);
	                break;
	        }
	        return _this;
	    }
	    Subscriber.prototype[rxSubscriber] = function () { return this; };
	    Subscriber.create = function (next, error, complete) {
	        var subscriber = new Subscriber(next, error, complete);
	        subscriber.syncErrorThrowable = false;
	        return subscriber;
	    };
	    Subscriber.prototype.next = function (value) {
	        if (!this.isStopped) {
	            this._next(value);
	        }
	    };
	    Subscriber.prototype.error = function (err) {
	        if (!this.isStopped) {
	            this.isStopped = true;
	            this._error(err);
	        }
	    };
	    Subscriber.prototype.complete = function () {
	        if (!this.isStopped) {
	            this.isStopped = true;
	            this._complete();
	        }
	    };
	    Subscriber.prototype.unsubscribe = function () {
	        if (this.closed) {
	            return;
	        }
	        this.isStopped = true;
	        _super.prototype.unsubscribe.call(this);
	    };
	    Subscriber.prototype._next = function (value) {
	        this.destination.next(value);
	    };
	    Subscriber.prototype._error = function (err) {
	        this.destination.error(err);
	        this.unsubscribe();
	    };
	    Subscriber.prototype._complete = function () {
	        this.destination.complete();
	        this.unsubscribe();
	    };
	    Subscriber.prototype._unsubscribeAndRecycle = function () {
	        var _parentOrParents = this._parentOrParents;
	        this._parentOrParents = null;
	        this.unsubscribe();
	        this.closed = false;
	        this.isStopped = false;
	        this._parentOrParents = _parentOrParents;
	        return this;
	    };
	    return Subscriber;
	}(Subscription));
	var SafeSubscriber = /*@__PURE__*/ (function (_super) {
	    __extends(SafeSubscriber, _super);
	    function SafeSubscriber(_parentSubscriber, observerOrNext, error, complete) {
	        var _this = _super.call(this) || this;
	        _this._parentSubscriber = _parentSubscriber;
	        var next;
	        var context = _this;
	        if (isFunction(observerOrNext)) {
	            next = observerOrNext;
	        }
	        else if (observerOrNext) {
	            next = observerOrNext.next;
	            error = observerOrNext.error;
	            complete = observerOrNext.complete;
	            if (observerOrNext !== empty$1) {
	                context = Object.create(observerOrNext);
	                if (isFunction(context.unsubscribe)) {
	                    _this.add(context.unsubscribe.bind(context));
	                }
	                context.unsubscribe = _this.unsubscribe.bind(_this);
	            }
	        }
	        _this._context = context;
	        _this._next = next;
	        _this._error = error;
	        _this._complete = complete;
	        return _this;
	    }
	    SafeSubscriber.prototype.next = function (value) {
	        if (!this.isStopped && this._next) {
	            var _parentSubscriber = this._parentSubscriber;
	            if (!config.useDeprecatedSynchronousErrorHandling || !_parentSubscriber.syncErrorThrowable) {
	                this.__tryOrUnsub(this._next, value);
	            }
	            else if (this.__tryOrSetError(_parentSubscriber, this._next, value)) {
	                this.unsubscribe();
	            }
	        }
	    };
	    SafeSubscriber.prototype.error = function (err) {
	        if (!this.isStopped) {
	            var _parentSubscriber = this._parentSubscriber;
	            var useDeprecatedSynchronousErrorHandling = config.useDeprecatedSynchronousErrorHandling;
	            if (this._error) {
	                if (!useDeprecatedSynchronousErrorHandling || !_parentSubscriber.syncErrorThrowable) {
	                    this.__tryOrUnsub(this._error, err);
	                    this.unsubscribe();
	                }
	                else {
	                    this.__tryOrSetError(_parentSubscriber, this._error, err);
	                    this.unsubscribe();
	                }
	            }
	            else if (!_parentSubscriber.syncErrorThrowable) {
	                this.unsubscribe();
	                if (useDeprecatedSynchronousErrorHandling) {
	                    throw err;
	                }
	                hostReportError(err);
	            }
	            else {
	                if (useDeprecatedSynchronousErrorHandling) {
	                    _parentSubscriber.syncErrorValue = err;
	                    _parentSubscriber.syncErrorThrown = true;
	                }
	                else {
	                    hostReportError(err);
	                }
	                this.unsubscribe();
	            }
	        }
	    };
	    SafeSubscriber.prototype.complete = function () {
	        var _this = this;
	        if (!this.isStopped) {
	            var _parentSubscriber = this._parentSubscriber;
	            if (this._complete) {
	                var wrappedComplete = function () { return _this._complete.call(_this._context); };
	                if (!config.useDeprecatedSynchronousErrorHandling || !_parentSubscriber.syncErrorThrowable) {
	                    this.__tryOrUnsub(wrappedComplete);
	                    this.unsubscribe();
	                }
	                else {
	                    this.__tryOrSetError(_parentSubscriber, wrappedComplete);
	                    this.unsubscribe();
	                }
	            }
	            else {
	                this.unsubscribe();
	            }
	        }
	    };
	    SafeSubscriber.prototype.__tryOrUnsub = function (fn, value) {
	        try {
	            fn.call(this._context, value);
	        }
	        catch (err) {
	            this.unsubscribe();
	            if (config.useDeprecatedSynchronousErrorHandling) {
	                throw err;
	            }
	            else {
	                hostReportError(err);
	            }
	        }
	    };
	    SafeSubscriber.prototype.__tryOrSetError = function (parent, fn, value) {
	        if (!config.useDeprecatedSynchronousErrorHandling) {
	            throw new Error('bad call');
	        }
	        try {
	            fn.call(this._context, value);
	        }
	        catch (err) {
	            if (config.useDeprecatedSynchronousErrorHandling) {
	                parent.syncErrorValue = err;
	                parent.syncErrorThrown = true;
	                return true;
	            }
	            else {
	                hostReportError(err);
	                return true;
	            }
	        }
	        return false;
	    };
	    SafeSubscriber.prototype._unsubscribe = function () {
	        var _parentSubscriber = this._parentSubscriber;
	        this._context = null;
	        this._parentSubscriber = null;
	        _parentSubscriber.unsubscribe();
	    };
	    return SafeSubscriber;
	}(Subscriber));

	/** PURE_IMPORTS_START _Subscriber PURE_IMPORTS_END */
	function canReportError(observer) {
	    while (observer) {
	        var _a = observer, closed_1 = _a.closed, destination = _a.destination, isStopped = _a.isStopped;
	        if (closed_1 || isStopped) {
	            return false;
	        }
	        else if (destination && destination instanceof Subscriber) {
	            observer = destination;
	        }
	        else {
	            observer = null;
	        }
	    }
	    return true;
	}

	/** PURE_IMPORTS_START _Subscriber,_symbol_rxSubscriber,_Observer PURE_IMPORTS_END */
	function toSubscriber(nextOrObserver, error, complete) {
	    if (nextOrObserver) {
	        if (nextOrObserver instanceof Subscriber) {
	            return nextOrObserver;
	        }
	        if (nextOrObserver[rxSubscriber]) {
	            return nextOrObserver[rxSubscriber]();
	        }
	    }
	    if (!nextOrObserver && !error && !complete) {
	        return new Subscriber(empty$1);
	    }
	    return new Subscriber(nextOrObserver, error, complete);
	}

	/** PURE_IMPORTS_START  PURE_IMPORTS_END */
	var observable = /*@__PURE__*/ (function () { return typeof Symbol === 'function' && Symbol.observable || '@@observable'; })();

	/** PURE_IMPORTS_START  PURE_IMPORTS_END */
	function identity(x) {
	    return x;
	}

	/** PURE_IMPORTS_START _identity PURE_IMPORTS_END */
	function pipe() {
	    var fns = [];
	    for (var _i = 0; _i < arguments.length; _i++) {
	        fns[_i] = arguments[_i];
	    }
	    return pipeFromArray(fns);
	}
	function pipeFromArray(fns) {
	    if (fns.length === 0) {
	        return identity;
	    }
	    if (fns.length === 1) {
	        return fns[0];
	    }
	    return function piped(input) {
	        return fns.reduce(function (prev, fn) { return fn(prev); }, input);
	    };
	}

	/** PURE_IMPORTS_START _util_canReportError,_util_toSubscriber,_symbol_observable,_util_pipe,_config PURE_IMPORTS_END */
	var Observable = /*@__PURE__*/ (function () {
	    function Observable(subscribe) {
	        this._isScalar = false;
	        if (subscribe) {
	            this._subscribe = subscribe;
	        }
	    }
	    Observable.prototype.lift = function (operator) {
	        var observable = new Observable();
	        observable.source = this;
	        observable.operator = operator;
	        return observable;
	    };
	    Observable.prototype.subscribe = function (observerOrNext, error, complete) {
	        var operator = this.operator;
	        var sink = toSubscriber(observerOrNext, error, complete);
	        if (operator) {
	            sink.add(operator.call(sink, this.source));
	        }
	        else {
	            sink.add(this.source || (config.useDeprecatedSynchronousErrorHandling && !sink.syncErrorThrowable) ?
	                this._subscribe(sink) :
	                this._trySubscribe(sink));
	        }
	        if (config.useDeprecatedSynchronousErrorHandling) {
	            if (sink.syncErrorThrowable) {
	                sink.syncErrorThrowable = false;
	                if (sink.syncErrorThrown) {
	                    throw sink.syncErrorValue;
	                }
	            }
	        }
	        return sink;
	    };
	    Observable.prototype._trySubscribe = function (sink) {
	        try {
	            return this._subscribe(sink);
	        }
	        catch (err) {
	            if (config.useDeprecatedSynchronousErrorHandling) {
	                sink.syncErrorThrown = true;
	                sink.syncErrorValue = err;
	            }
	            if (canReportError(sink)) {
	                sink.error(err);
	            }
	            else {
	                console.warn(err);
	            }
	        }
	    };
	    Observable.prototype.forEach = function (next, promiseCtor) {
	        var _this = this;
	        promiseCtor = getPromiseCtor(promiseCtor);
	        return new promiseCtor(function (resolve, reject) {
	            var subscription;
	            subscription = _this.subscribe(function (value) {
	                try {
	                    next(value);
	                }
	                catch (err) {
	                    reject(err);
	                    if (subscription) {
	                        subscription.unsubscribe();
	                    }
	                }
	            }, reject, resolve);
	        });
	    };
	    Observable.prototype._subscribe = function (subscriber) {
	        var source = this.source;
	        return source && source.subscribe(subscriber);
	    };
	    Observable.prototype[observable] = function () {
	        return this;
	    };
	    Observable.prototype.pipe = function () {
	        var operations = [];
	        for (var _i = 0; _i < arguments.length; _i++) {
	            operations[_i] = arguments[_i];
	        }
	        if (operations.length === 0) {
	            return this;
	        }
	        return pipeFromArray(operations)(this);
	    };
	    Observable.prototype.toPromise = function (promiseCtor) {
	        var _this = this;
	        promiseCtor = getPromiseCtor(promiseCtor);
	        return new promiseCtor(function (resolve, reject) {
	            var value;
	            _this.subscribe(function (x) { return value = x; }, function (err) { return reject(err); }, function () { return resolve(value); });
	        });
	    };
	    Observable.create = function (subscribe) {
	        return new Observable(subscribe);
	    };
	    return Observable;
	}());
	function getPromiseCtor(promiseCtor) {
	    if (!promiseCtor) {
	        promiseCtor = Promise;
	    }
	    if (!promiseCtor) {
	        throw new Error('no Promise impl found');
	    }
	    return promiseCtor;
	}

	/** PURE_IMPORTS_START  PURE_IMPORTS_END */
	var ObjectUnsubscribedErrorImpl = /*@__PURE__*/ (function () {
	    function ObjectUnsubscribedErrorImpl() {
	        Error.call(this);
	        this.message = 'object unsubscribed';
	        this.name = 'ObjectUnsubscribedError';
	        return this;
	    }
	    ObjectUnsubscribedErrorImpl.prototype = /*@__PURE__*/ Object.create(Error.prototype);
	    return ObjectUnsubscribedErrorImpl;
	})();
	var ObjectUnsubscribedError = ObjectUnsubscribedErrorImpl;

	/** PURE_IMPORTS_START tslib,_Subscription PURE_IMPORTS_END */
	var SubjectSubscription = /*@__PURE__*/ (function (_super) {
	    __extends(SubjectSubscription, _super);
	    function SubjectSubscription(subject, subscriber) {
	        var _this = _super.call(this) || this;
	        _this.subject = subject;
	        _this.subscriber = subscriber;
	        _this.closed = false;
	        return _this;
	    }
	    SubjectSubscription.prototype.unsubscribe = function () {
	        if (this.closed) {
	            return;
	        }
	        this.closed = true;
	        var subject = this.subject;
	        var observers = subject.observers;
	        this.subject = null;
	        if (!observers || observers.length === 0 || subject.isStopped || subject.closed) {
	            return;
	        }
	        var subscriberIndex = observers.indexOf(this.subscriber);
	        if (subscriberIndex !== -1) {
	            observers.splice(subscriberIndex, 1);
	        }
	    };
	    return SubjectSubscription;
	}(Subscription));

	/** PURE_IMPORTS_START tslib,_Observable,_Subscriber,_Subscription,_util_ObjectUnsubscribedError,_SubjectSubscription,_internal_symbol_rxSubscriber PURE_IMPORTS_END */
	var SubjectSubscriber = /*@__PURE__*/ (function (_super) {
	    __extends(SubjectSubscriber, _super);
	    function SubjectSubscriber(destination) {
	        var _this = _super.call(this, destination) || this;
	        _this.destination = destination;
	        return _this;
	    }
	    return SubjectSubscriber;
	}(Subscriber));
	var Subject = /*@__PURE__*/ (function (_super) {
	    __extends(Subject, _super);
	    function Subject() {
	        var _this = _super.call(this) || this;
	        _this.observers = [];
	        _this.closed = false;
	        _this.isStopped = false;
	        _this.hasError = false;
	        _this.thrownError = null;
	        return _this;
	    }
	    Subject.prototype[rxSubscriber] = function () {
	        return new SubjectSubscriber(this);
	    };
	    Subject.prototype.lift = function (operator) {
	        var subject = new AnonymousSubject(this, this);
	        subject.operator = operator;
	        return subject;
	    };
	    Subject.prototype.next = function (value) {
	        if (this.closed) {
	            throw new ObjectUnsubscribedError();
	        }
	        if (!this.isStopped) {
	            var observers = this.observers;
	            var len = observers.length;
	            var copy = observers.slice();
	            for (var i = 0; i < len; i++) {
	                copy[i].next(value);
	            }
	        }
	    };
	    Subject.prototype.error = function (err) {
	        if (this.closed) {
	            throw new ObjectUnsubscribedError();
	        }
	        this.hasError = true;
	        this.thrownError = err;
	        this.isStopped = true;
	        var observers = this.observers;
	        var len = observers.length;
	        var copy = observers.slice();
	        for (var i = 0; i < len; i++) {
	            copy[i].error(err);
	        }
	        this.observers.length = 0;
	    };
	    Subject.prototype.complete = function () {
	        if (this.closed) {
	            throw new ObjectUnsubscribedError();
	        }
	        this.isStopped = true;
	        var observers = this.observers;
	        var len = observers.length;
	        var copy = observers.slice();
	        for (var i = 0; i < len; i++) {
	            copy[i].complete();
	        }
	        this.observers.length = 0;
	    };
	    Subject.prototype.unsubscribe = function () {
	        this.isStopped = true;
	        this.closed = true;
	        this.observers = null;
	    };
	    Subject.prototype._trySubscribe = function (subscriber) {
	        if (this.closed) {
	            throw new ObjectUnsubscribedError();
	        }
	        else {
	            return _super.prototype._trySubscribe.call(this, subscriber);
	        }
	    };
	    Subject.prototype._subscribe = function (subscriber) {
	        if (this.closed) {
	            throw new ObjectUnsubscribedError();
	        }
	        else if (this.hasError) {
	            subscriber.error(this.thrownError);
	            return Subscription.EMPTY;
	        }
	        else if (this.isStopped) {
	            subscriber.complete();
	            return Subscription.EMPTY;
	        }
	        else {
	            this.observers.push(subscriber);
	            return new SubjectSubscription(this, subscriber);
	        }
	    };
	    Subject.prototype.asObservable = function () {
	        var observable = new Observable();
	        observable.source = this;
	        return observable;
	    };
	    Subject.create = function (destination, source) {
	        return new AnonymousSubject(destination, source);
	    };
	    return Subject;
	}(Observable));
	var AnonymousSubject = /*@__PURE__*/ (function (_super) {
	    __extends(AnonymousSubject, _super);
	    function AnonymousSubject(destination, source) {
	        var _this = _super.call(this) || this;
	        _this.destination = destination;
	        _this.source = source;
	        return _this;
	    }
	    AnonymousSubject.prototype.next = function (value) {
	        var destination = this.destination;
	        if (destination && destination.next) {
	            destination.next(value);
	        }
	    };
	    AnonymousSubject.prototype.error = function (err) {
	        var destination = this.destination;
	        if (destination && destination.error) {
	            this.destination.error(err);
	        }
	    };
	    AnonymousSubject.prototype.complete = function () {
	        var destination = this.destination;
	        if (destination && destination.complete) {
	            this.destination.complete();
	        }
	    };
	    AnonymousSubject.prototype._subscribe = function (subscriber) {
	        var source = this.source;
	        if (source) {
	            return this.source.subscribe(subscriber);
	        }
	        else {
	            return Subscription.EMPTY;
	        }
	    };
	    return AnonymousSubject;
	}(Subject));

	/** PURE_IMPORTS_START tslib,_Subscription PURE_IMPORTS_END */
	var Action = /*@__PURE__*/ (function (_super) {
	    __extends(Action, _super);
	    function Action(scheduler, work) {
	        return _super.call(this) || this;
	    }
	    Action.prototype.schedule = function (state, delay) {
	        return this;
	    };
	    return Action;
	}(Subscription));

	/** PURE_IMPORTS_START tslib,_Action PURE_IMPORTS_END */
	var AsyncAction = /*@__PURE__*/ (function (_super) {
	    __extends(AsyncAction, _super);
	    function AsyncAction(scheduler, work) {
	        var _this = _super.call(this, scheduler, work) || this;
	        _this.scheduler = scheduler;
	        _this.work = work;
	        _this.pending = false;
	        return _this;
	    }
	    AsyncAction.prototype.schedule = function (state, delay) {
	        if (delay === void 0) {
	            delay = 0;
	        }
	        if (this.closed) {
	            return this;
	        }
	        this.state = state;
	        var id = this.id;
	        var scheduler = this.scheduler;
	        if (id != null) {
	            this.id = this.recycleAsyncId(scheduler, id, delay);
	        }
	        this.pending = true;
	        this.delay = delay;
	        this.id = this.id || this.requestAsyncId(scheduler, this.id, delay);
	        return this;
	    };
	    AsyncAction.prototype.requestAsyncId = function (scheduler, id, delay) {
	        if (delay === void 0) {
	            delay = 0;
	        }
	        return setInterval(scheduler.flush.bind(scheduler, this), delay);
	    };
	    AsyncAction.prototype.recycleAsyncId = function (scheduler, id, delay) {
	        if (delay === void 0) {
	            delay = 0;
	        }
	        if (delay !== null && this.delay === delay && this.pending === false) {
	            return id;
	        }
	        clearInterval(id);
	        return undefined;
	    };
	    AsyncAction.prototype.execute = function (state, delay) {
	        if (this.closed) {
	            return new Error('executing a cancelled action');
	        }
	        this.pending = false;
	        var error = this._execute(state, delay);
	        if (error) {
	            return error;
	        }
	        else if (this.pending === false && this.id != null) {
	            this.id = this.recycleAsyncId(this.scheduler, this.id, null);
	        }
	    };
	    AsyncAction.prototype._execute = function (state, delay) {
	        var errored = false;
	        var errorValue = undefined;
	        try {
	            this.work(state);
	        }
	        catch (e) {
	            errored = true;
	            errorValue = !!e && e || new Error(e);
	        }
	        if (errored) {
	            this.unsubscribe();
	            return errorValue;
	        }
	    };
	    AsyncAction.prototype._unsubscribe = function () {
	        var id = this.id;
	        var scheduler = this.scheduler;
	        var actions = scheduler.actions;
	        var index = actions.indexOf(this);
	        this.work = null;
	        this.state = null;
	        this.pending = false;
	        this.scheduler = null;
	        if (index !== -1) {
	            actions.splice(index, 1);
	        }
	        if (id != null) {
	            this.id = this.recycleAsyncId(scheduler, id, null);
	        }
	        this.delay = null;
	    };
	    return AsyncAction;
	}(Action));

	/** PURE_IMPORTS_START tslib,_AsyncAction PURE_IMPORTS_END */
	var QueueAction = /*@__PURE__*/ (function (_super) {
	    __extends(QueueAction, _super);
	    function QueueAction(scheduler, work) {
	        var _this = _super.call(this, scheduler, work) || this;
	        _this.scheduler = scheduler;
	        _this.work = work;
	        return _this;
	    }
	    QueueAction.prototype.schedule = function (state, delay) {
	        if (delay === void 0) {
	            delay = 0;
	        }
	        if (delay > 0) {
	            return _super.prototype.schedule.call(this, state, delay);
	        }
	        this.delay = delay;
	        this.state = state;
	        this.scheduler.flush(this);
	        return this;
	    };
	    QueueAction.prototype.execute = function (state, delay) {
	        return (delay > 0 || this.closed) ?
	            _super.prototype.execute.call(this, state, delay) :
	            this._execute(state, delay);
	    };
	    QueueAction.prototype.requestAsyncId = function (scheduler, id, delay) {
	        if (delay === void 0) {
	            delay = 0;
	        }
	        if ((delay !== null && delay > 0) || (delay === null && this.delay > 0)) {
	            return _super.prototype.requestAsyncId.call(this, scheduler, id, delay);
	        }
	        return scheduler.flush(this);
	    };
	    return QueueAction;
	}(AsyncAction));

	var Scheduler = /*@__PURE__*/ (function () {
	    function Scheduler(SchedulerAction, now) {
	        if (now === void 0) {
	            now = Scheduler.now;
	        }
	        this.SchedulerAction = SchedulerAction;
	        this.now = now;
	    }
	    Scheduler.prototype.schedule = function (work, delay, state) {
	        if (delay === void 0) {
	            delay = 0;
	        }
	        return new this.SchedulerAction(this, work).schedule(state, delay);
	    };
	    Scheduler.now = function () { return Date.now(); };
	    return Scheduler;
	}());

	/** PURE_IMPORTS_START tslib,_Scheduler PURE_IMPORTS_END */
	var AsyncScheduler = /*@__PURE__*/ (function (_super) {
	    __extends(AsyncScheduler, _super);
	    function AsyncScheduler(SchedulerAction, now) {
	        if (now === void 0) {
	            now = Scheduler.now;
	        }
	        var _this = _super.call(this, SchedulerAction, function () {
	            if (AsyncScheduler.delegate && AsyncScheduler.delegate !== _this) {
	                return AsyncScheduler.delegate.now();
	            }
	            else {
	                return now();
	            }
	        }) || this;
	        _this.actions = [];
	        _this.active = false;
	        _this.scheduled = undefined;
	        return _this;
	    }
	    AsyncScheduler.prototype.schedule = function (work, delay, state) {
	        if (delay === void 0) {
	            delay = 0;
	        }
	        if (AsyncScheduler.delegate && AsyncScheduler.delegate !== this) {
	            return AsyncScheduler.delegate.schedule(work, delay, state);
	        }
	        else {
	            return _super.prototype.schedule.call(this, work, delay, state);
	        }
	    };
	    AsyncScheduler.prototype.flush = function (action) {
	        var actions = this.actions;
	        if (this.active) {
	            actions.push(action);
	            return;
	        }
	        var error;
	        this.active = true;
	        do {
	            if (error = action.execute(action.state, action.delay)) {
	                break;
	            }
	        } while (action = actions.shift());
	        this.active = false;
	        if (error) {
	            while (action = actions.shift()) {
	                action.unsubscribe();
	            }
	            throw error;
	        }
	    };
	    return AsyncScheduler;
	}(Scheduler));

	/** PURE_IMPORTS_START tslib,_AsyncScheduler PURE_IMPORTS_END */
	var QueueScheduler = /*@__PURE__*/ (function (_super) {
	    __extends(QueueScheduler, _super);
	    function QueueScheduler() {
	        return _super !== null && _super.apply(this, arguments) || this;
	    }
	    return QueueScheduler;
	}(AsyncScheduler));

	/** PURE_IMPORTS_START _QueueAction,_QueueScheduler PURE_IMPORTS_END */
	var queueScheduler = /*@__PURE__*/ new QueueScheduler(QueueAction);
	var queue = queueScheduler;

	/** PURE_IMPORTS_START _Observable PURE_IMPORTS_END */
	var EMPTY = /*@__PURE__*/ new Observable(function (subscriber) { return subscriber.complete(); });
	function empty(scheduler) {
	    return EMPTY;
	}

	/** PURE_IMPORTS_START  PURE_IMPORTS_END */
	function isScheduler(value) {
	    return value && typeof value.schedule === 'function';
	}

	/** PURE_IMPORTS_START  PURE_IMPORTS_END */
	var subscribeToArray = function (array) {
	    return function (subscriber) {
	        for (var i = 0, len = array.length; i < len && !subscriber.closed; i++) {
	            subscriber.next(array[i]);
	        }
	        subscriber.complete();
	    };
	};

	/** PURE_IMPORTS_START _Observable,_Subscription PURE_IMPORTS_END */
	function scheduleArray(input, scheduler) {
	    return new Observable(function (subscriber) {
	        var sub = new Subscription();
	        var i = 0;
	        sub.add(scheduler.schedule(function () {
	            if (i === input.length) {
	                subscriber.complete();
	                return;
	            }
	            subscriber.next(input[i++]);
	            if (!subscriber.closed) {
	                sub.add(this.schedule());
	            }
	        }));
	        return sub;
	    });
	}

	/** PURE_IMPORTS_START _Observable,_util_subscribeToArray,_scheduled_scheduleArray PURE_IMPORTS_END */
	function fromArray(input, scheduler) {
	    if (!scheduler) {
	        return new Observable(subscribeToArray(input));
	    }
	    else {
	        return scheduleArray(input, scheduler);
	    }
	}

	/** PURE_IMPORTS_START _util_isScheduler,_fromArray,_scheduled_scheduleArray PURE_IMPORTS_END */
	function of() {
	    var args = [];
	    for (var _i = 0; _i < arguments.length; _i++) {
	        args[_i] = arguments[_i];
	    }
	    var scheduler = args[args.length - 1];
	    if (isScheduler(scheduler)) {
	        args.pop();
	        return scheduleArray(args, scheduler);
	    }
	    else {
	        return fromArray(args);
	    }
	}

	/** PURE_IMPORTS_START _Observable PURE_IMPORTS_END */
	function throwError(error, scheduler) {
	    {
	        return new Observable(function (subscriber) { return subscriber.error(error); });
	    }
	}

	/** PURE_IMPORTS_START _observable_empty,_observable_of,_observable_throwError PURE_IMPORTS_END */
	var Notification = /*@__PURE__*/ (function () {
	    function Notification(kind, value, error) {
	        this.kind = kind;
	        this.value = value;
	        this.error = error;
	        this.hasValue = kind === 'N';
	    }
	    Notification.prototype.observe = function (observer) {
	        switch (this.kind) {
	            case 'N':
	                return observer.next && observer.next(this.value);
	            case 'E':
	                return observer.error && observer.error(this.error);
	            case 'C':
	                return observer.complete && observer.complete();
	        }
	    };
	    Notification.prototype.do = function (next, error, complete) {
	        var kind = this.kind;
	        switch (kind) {
	            case 'N':
	                return next && next(this.value);
	            case 'E':
	                return error && error(this.error);
	            case 'C':
	                return complete && complete();
	        }
	    };
	    Notification.prototype.accept = function (nextOrObserver, error, complete) {
	        if (nextOrObserver && typeof nextOrObserver.next === 'function') {
	            return this.observe(nextOrObserver);
	        }
	        else {
	            return this.do(nextOrObserver, error, complete);
	        }
	    };
	    Notification.prototype.toObservable = function () {
	        var kind = this.kind;
	        switch (kind) {
	            case 'N':
	                return of(this.value);
	            case 'E':
	                return throwError(this.error);
	            case 'C':
	                return empty();
	        }
	        throw new Error('unexpected notification kind value');
	    };
	    Notification.createNext = function (value) {
	        if (typeof value !== 'undefined') {
	            return new Notification('N', value);
	        }
	        return Notification.undefinedValueNotification;
	    };
	    Notification.createError = function (err) {
	        return new Notification('E', undefined, err);
	    };
	    Notification.createComplete = function () {
	        return Notification.completeNotification;
	    };
	    Notification.completeNotification = new Notification('C');
	    Notification.undefinedValueNotification = new Notification('N', undefined);
	    return Notification;
	}());

	/** PURE_IMPORTS_START tslib,_Subscriber,_Notification PURE_IMPORTS_END */
	function observeOn(scheduler, delay) {
	    if (delay === void 0) {
	        delay = 0;
	    }
	    return function observeOnOperatorFunction(source) {
	        return source.lift(new ObserveOnOperator(scheduler, delay));
	    };
	}
	var ObserveOnOperator = /*@__PURE__*/ (function () {
	    function ObserveOnOperator(scheduler, delay) {
	        if (delay === void 0) {
	            delay = 0;
	        }
	        this.scheduler = scheduler;
	        this.delay = delay;
	    }
	    ObserveOnOperator.prototype.call = function (subscriber, source) {
	        return source.subscribe(new ObserveOnSubscriber(subscriber, this.scheduler, this.delay));
	    };
	    return ObserveOnOperator;
	}());
	var ObserveOnSubscriber = /*@__PURE__*/ (function (_super) {
	    __extends(ObserveOnSubscriber, _super);
	    function ObserveOnSubscriber(destination, scheduler, delay) {
	        if (delay === void 0) {
	            delay = 0;
	        }
	        var _this = _super.call(this, destination) || this;
	        _this.scheduler = scheduler;
	        _this.delay = delay;
	        return _this;
	    }
	    ObserveOnSubscriber.dispatch = function (arg) {
	        var notification = arg.notification, destination = arg.destination;
	        notification.observe(destination);
	        this.unsubscribe();
	    };
	    ObserveOnSubscriber.prototype.scheduleMessage = function (notification) {
	        var destination = this.destination;
	        destination.add(this.scheduler.schedule(ObserveOnSubscriber.dispatch, this.delay, new ObserveOnMessage(notification, this.destination)));
	    };
	    ObserveOnSubscriber.prototype._next = function (value) {
	        this.scheduleMessage(Notification.createNext(value));
	    };
	    ObserveOnSubscriber.prototype._error = function (err) {
	        this.scheduleMessage(Notification.createError(err));
	        this.unsubscribe();
	    };
	    ObserveOnSubscriber.prototype._complete = function () {
	        this.scheduleMessage(Notification.createComplete());
	        this.unsubscribe();
	    };
	    return ObserveOnSubscriber;
	}(Subscriber));
	var ObserveOnMessage = /*@__PURE__*/ (function () {
	    function ObserveOnMessage(notification, destination) {
	        this.notification = notification;
	        this.destination = destination;
	    }
	    return ObserveOnMessage;
	}());

	/** PURE_IMPORTS_START tslib,_Subject,_scheduler_queue,_Subscription,_operators_observeOn,_util_ObjectUnsubscribedError,_SubjectSubscription PURE_IMPORTS_END */
	var ReplaySubject = /*@__PURE__*/ (function (_super) {
	    __extends(ReplaySubject, _super);
	    function ReplaySubject(bufferSize, windowTime, scheduler) {
	        if (bufferSize === void 0) {
	            bufferSize = Number.POSITIVE_INFINITY;
	        }
	        if (windowTime === void 0) {
	            windowTime = Number.POSITIVE_INFINITY;
	        }
	        var _this = _super.call(this) || this;
	        _this.scheduler = scheduler;
	        _this._events = [];
	        _this._infiniteTimeWindow = false;
	        _this._bufferSize = bufferSize < 1 ? 1 : bufferSize;
	        _this._windowTime = windowTime < 1 ? 1 : windowTime;
	        if (windowTime === Number.POSITIVE_INFINITY) {
	            _this._infiniteTimeWindow = true;
	            _this.next = _this.nextInfiniteTimeWindow;
	        }
	        else {
	            _this.next = _this.nextTimeWindow;
	        }
	        return _this;
	    }
	    ReplaySubject.prototype.nextInfiniteTimeWindow = function (value) {
	        if (!this.isStopped) {
	            var _events = this._events;
	            _events.push(value);
	            if (_events.length > this._bufferSize) {
	                _events.shift();
	            }
	        }
	        _super.prototype.next.call(this, value);
	    };
	    ReplaySubject.prototype.nextTimeWindow = function (value) {
	        if (!this.isStopped) {
	            this._events.push(new ReplayEvent(this._getNow(), value));
	            this._trimBufferThenGetEvents();
	        }
	        _super.prototype.next.call(this, value);
	    };
	    ReplaySubject.prototype._subscribe = function (subscriber) {
	        var _infiniteTimeWindow = this._infiniteTimeWindow;
	        var _events = _infiniteTimeWindow ? this._events : this._trimBufferThenGetEvents();
	        var scheduler = this.scheduler;
	        var len = _events.length;
	        var subscription;
	        if (this.closed) {
	            throw new ObjectUnsubscribedError();
	        }
	        else if (this.isStopped || this.hasError) {
	            subscription = Subscription.EMPTY;
	        }
	        else {
	            this.observers.push(subscriber);
	            subscription = new SubjectSubscription(this, subscriber);
	        }
	        if (scheduler) {
	            subscriber.add(subscriber = new ObserveOnSubscriber(subscriber, scheduler));
	        }
	        if (_infiniteTimeWindow) {
	            for (var i = 0; i < len && !subscriber.closed; i++) {
	                subscriber.next(_events[i]);
	            }
	        }
	        else {
	            for (var i = 0; i < len && !subscriber.closed; i++) {
	                subscriber.next(_events[i].value);
	            }
	        }
	        if (this.hasError) {
	            subscriber.error(this.thrownError);
	        }
	        else if (this.isStopped) {
	            subscriber.complete();
	        }
	        return subscription;
	    };
	    ReplaySubject.prototype._getNow = function () {
	        return (this.scheduler || queue).now();
	    };
	    ReplaySubject.prototype._trimBufferThenGetEvents = function () {
	        var now = this._getNow();
	        var _bufferSize = this._bufferSize;
	        var _windowTime = this._windowTime;
	        var _events = this._events;
	        var eventsCount = _events.length;
	        var spliceCount = 0;
	        while (spliceCount < eventsCount) {
	            if ((now - _events[spliceCount].time) < _windowTime) {
	                break;
	            }
	            spliceCount++;
	        }
	        if (eventsCount > _bufferSize) {
	            spliceCount = Math.max(spliceCount, eventsCount - _bufferSize);
	        }
	        if (spliceCount > 0) {
	            _events.splice(0, spliceCount);
	        }
	        return _events;
	    };
	    return ReplaySubject;
	}(Subject));
	var ReplayEvent = /*@__PURE__*/ (function () {
	    function ReplayEvent(time, value) {
	        this.time = time;
	        this.value = value;
	    }
	    return ReplayEvent;
	}());

	/** PURE_IMPORTS_START tslib,_.._Subject,_.._Subscriber,_.._Observable,_.._Subscription,_.._ReplaySubject PURE_IMPORTS_END */
	var DEFAULT_WEBSOCKET_CONFIG = {
	    url: '',
	    deserializer: function (e) { return JSON.parse(e.data); },
	    serializer: function (value) { return JSON.stringify(value); },
	};
	var WEBSOCKETSUBJECT_INVALID_ERROR_OBJECT = 'WebSocketSubject.error must be called with an object with an error code, and an optional reason: { code: number, reason: string }';
	var WebSocketSubject = /*@__PURE__*/ (function (_super) {
	    __extends(WebSocketSubject, _super);
	    function WebSocketSubject(urlConfigOrSource, destination) {
	        var _this = _super.call(this) || this;
	        if (urlConfigOrSource instanceof Observable) {
	            _this.destination = destination;
	            _this.source = urlConfigOrSource;
	        }
	        else {
	            var config = _this._config = __assign({}, DEFAULT_WEBSOCKET_CONFIG);
	            _this._output = new Subject();
	            if (typeof urlConfigOrSource === 'string') {
	                config.url = urlConfigOrSource;
	            }
	            else {
	                for (var key in urlConfigOrSource) {
	                    if (urlConfigOrSource.hasOwnProperty(key)) {
	                        config[key] = urlConfigOrSource[key];
	                    }
	                }
	            }
	            if (!config.WebSocketCtor && WebSocket) {
	                config.WebSocketCtor = WebSocket;
	            }
	            else if (!config.WebSocketCtor) {
	                throw new Error('no WebSocket constructor can be found');
	            }
	            _this.destination = new ReplaySubject();
	        }
	        return _this;
	    }
	    WebSocketSubject.prototype.lift = function (operator) {
	        var sock = new WebSocketSubject(this._config, this.destination);
	        sock.operator = operator;
	        sock.source = this;
	        return sock;
	    };
	    WebSocketSubject.prototype._resetState = function () {
	        this._socket = null;
	        if (!this.source) {
	            this.destination = new ReplaySubject();
	        }
	        this._output = new Subject();
	    };
	    WebSocketSubject.prototype.multiplex = function (subMsg, unsubMsg, messageFilter) {
	        var self = this;
	        return new Observable(function (observer) {
	            try {
	                self.next(subMsg());
	            }
	            catch (err) {
	                observer.error(err);
	            }
	            var subscription = self.subscribe(function (x) {
	                try {
	                    if (messageFilter(x)) {
	                        observer.next(x);
	                    }
	                }
	                catch (err) {
	                    observer.error(err);
	                }
	            }, function (err) { return observer.error(err); }, function () { return observer.complete(); });
	            return function () {
	                try {
	                    self.next(unsubMsg());
	                }
	                catch (err) {
	                    observer.error(err);
	                }
	                subscription.unsubscribe();
	            };
	        });
	    };
	    WebSocketSubject.prototype._connectSocket = function () {
	        var _this = this;
	        var _a = this._config, WebSocketCtor = _a.WebSocketCtor, protocol = _a.protocol, url = _a.url, binaryType = _a.binaryType;
	        var observer = this._output;
	        var socket = null;
	        try {
	            socket = protocol ?
	                new WebSocketCtor(url, protocol) :
	                new WebSocketCtor(url);
	            this._socket = socket;
	            if (binaryType) {
	                this._socket.binaryType = binaryType;
	            }
	        }
	        catch (e) {
	            observer.error(e);
	            return;
	        }
	        var subscription = new Subscription(function () {
	            _this._socket = null;
	            if (socket && socket.readyState === 1) {
	                socket.close();
	            }
	        });
	        socket.onopen = function (e) {
	            var _socket = _this._socket;
	            if (!_socket) {
	                socket.close();
	                _this._resetState();
	                return;
	            }
	            var openObserver = _this._config.openObserver;
	            if (openObserver) {
	                openObserver.next(e);
	            }
	            var queue = _this.destination;
	            _this.destination = Subscriber.create(function (x) {
	                if (socket.readyState === 1) {
	                    try {
	                        var serializer = _this._config.serializer;
	                        socket.send(serializer(x));
	                    }
	                    catch (e) {
	                        _this.destination.error(e);
	                    }
	                }
	            }, function (e) {
	                var closingObserver = _this._config.closingObserver;
	                if (closingObserver) {
	                    closingObserver.next(undefined);
	                }
	                if (e && e.code) {
	                    socket.close(e.code, e.reason);
	                }
	                else {
	                    observer.error(new TypeError(WEBSOCKETSUBJECT_INVALID_ERROR_OBJECT));
	                }
	                _this._resetState();
	            }, function () {
	                var closingObserver = _this._config.closingObserver;
	                if (closingObserver) {
	                    closingObserver.next(undefined);
	                }
	                socket.close();
	                _this._resetState();
	            });
	            if (queue && queue instanceof ReplaySubject) {
	                subscription.add(queue.subscribe(_this.destination));
	            }
	        };
	        socket.onerror = function (e) {
	            _this._resetState();
	            observer.error(e);
	        };
	        socket.onclose = function (e) {
	            _this._resetState();
	            var closeObserver = _this._config.closeObserver;
	            if (closeObserver) {
	                closeObserver.next(e);
	            }
	            if (e.wasClean) {
	                observer.complete();
	            }
	            else {
	                observer.error(e);
	            }
	        };
	        socket.onmessage = function (e) {
	            try {
	                var deserializer = _this._config.deserializer;
	                observer.next(deserializer(e));
	            }
	            catch (err) {
	                observer.error(err);
	            }
	        };
	    };
	    WebSocketSubject.prototype._subscribe = function (subscriber) {
	        var _this = this;
	        var source = this.source;
	        if (source) {
	            return source.subscribe(subscriber);
	        }
	        if (!this._socket) {
	            this._connectSocket();
	        }
	        this._output.subscribe(subscriber);
	        subscriber.add(function () {
	            var _socket = _this._socket;
	            if (_this._output.observers.length === 0) {
	                if (_socket && _socket.readyState === 1) {
	                    _socket.close();
	                }
	                _this._resetState();
	            }
	        });
	        return subscriber;
	    };
	    WebSocketSubject.prototype.unsubscribe = function () {
	        var _socket = this._socket;
	        if (_socket && _socket.readyState === 1) {
	            _socket.close();
	        }
	        this._resetState();
	        _super.prototype.unsubscribe.call(this);
	    };
	    return WebSocketSubject;
	}(AnonymousSubject));

	/** PURE_IMPORTS_START _WebSocketSubject PURE_IMPORTS_END */
	function webSocket$1(urlConfigOrSource) {
	    return new WebSocketSubject(urlConfigOrSource);
	}

	/** PURE_IMPORTS_START  PURE_IMPORTS_END */

	var webSocket = /*#__PURE__*/Object.freeze({
		__proto__: null,
		WebSocketSubject: WebSocketSubject,
		webSocket: webSocket$1
	});

	var require$$0 = /*@__PURE__*/getAugmentedNamespace(webSocket);

	/** PURE_IMPORTS_START _hostReportError PURE_IMPORTS_END */
	var subscribeToPromise = function (promise) {
	    return function (subscriber) {
	        promise.then(function (value) {
	            if (!subscriber.closed) {
	                subscriber.next(value);
	                subscriber.complete();
	            }
	        }, function (err) { return subscriber.error(err); })
	            .then(null, hostReportError);
	        return subscriber;
	    };
	};

	/** PURE_IMPORTS_START  PURE_IMPORTS_END */
	function getSymbolIterator() {
	    if (typeof Symbol !== 'function' || !Symbol.iterator) {
	        return '@@iterator';
	    }
	    return Symbol.iterator;
	}
	var iterator = /*@__PURE__*/ getSymbolIterator();

	/** PURE_IMPORTS_START _symbol_iterator PURE_IMPORTS_END */
	var subscribeToIterable = function (iterable) {
	    return function (subscriber) {
	        var iterator$1 = iterable[iterator]();
	        do {
	            var item = void 0;
	            try {
	                item = iterator$1.next();
	            }
	            catch (err) {
	                subscriber.error(err);
	                return subscriber;
	            }
	            if (item.done) {
	                subscriber.complete();
	                break;
	            }
	            subscriber.next(item.value);
	            if (subscriber.closed) {
	                break;
	            }
	        } while (true);
	        if (typeof iterator$1.return === 'function') {
	            subscriber.add(function () {
	                if (iterator$1.return) {
	                    iterator$1.return();
	                }
	            });
	        }
	        return subscriber;
	    };
	};

	/** PURE_IMPORTS_START _symbol_observable PURE_IMPORTS_END */
	var subscribeToObservable = function (obj) {
	    return function (subscriber) {
	        var obs = obj[observable]();
	        if (typeof obs.subscribe !== 'function') {
	            throw new TypeError('Provided object does not correctly implement Symbol.observable');
	        }
	        else {
	            return obs.subscribe(subscriber);
	        }
	    };
	};

	/** PURE_IMPORTS_START  PURE_IMPORTS_END */
	var isArrayLike = (function (x) { return x && typeof x.length === 'number' && typeof x !== 'function'; });

	/** PURE_IMPORTS_START  PURE_IMPORTS_END */
	function isPromise(value) {
	    return !!value && typeof value.subscribe !== 'function' && typeof value.then === 'function';
	}

	/** PURE_IMPORTS_START _subscribeToArray,_subscribeToPromise,_subscribeToIterable,_subscribeToObservable,_isArrayLike,_isPromise,_isObject,_symbol_iterator,_symbol_observable PURE_IMPORTS_END */
	var subscribeTo = function (result) {
	    if (!!result && typeof result[observable] === 'function') {
	        return subscribeToObservable(result);
	    }
	    else if (isArrayLike(result)) {
	        return subscribeToArray(result);
	    }
	    else if (isPromise(result)) {
	        return subscribeToPromise(result);
	    }
	    else if (!!result && typeof result[iterator] === 'function') {
	        return subscribeToIterable(result);
	    }
	    else {
	        var value = isObject(result) ? 'an invalid object' : "'" + result + "'";
	        var msg = "You provided " + value + " where a stream was expected."
	            + ' You can provide an Observable, Promise, Array, or Iterable.';
	        throw new TypeError(msg);
	    }
	};

	/** PURE_IMPORTS_START tslib,_Subscriber,_Observable,_util_subscribeTo PURE_IMPORTS_END */
	var SimpleInnerSubscriber = /*@__PURE__*/ (function (_super) {
	    __extends(SimpleInnerSubscriber, _super);
	    function SimpleInnerSubscriber(parent) {
	        var _this = _super.call(this) || this;
	        _this.parent = parent;
	        return _this;
	    }
	    SimpleInnerSubscriber.prototype._next = function (value) {
	        this.parent.notifyNext(value);
	    };
	    SimpleInnerSubscriber.prototype._error = function (error) {
	        this.parent.notifyError(error);
	        this.unsubscribe();
	    };
	    SimpleInnerSubscriber.prototype._complete = function () {
	        this.parent.notifyComplete();
	        this.unsubscribe();
	    };
	    return SimpleInnerSubscriber;
	}(Subscriber));
	var SimpleOuterSubscriber = /*@__PURE__*/ (function (_super) {
	    __extends(SimpleOuterSubscriber, _super);
	    function SimpleOuterSubscriber() {
	        return _super !== null && _super.apply(this, arguments) || this;
	    }
	    SimpleOuterSubscriber.prototype.notifyNext = function (innerValue) {
	        this.destination.next(innerValue);
	    };
	    SimpleOuterSubscriber.prototype.notifyError = function (err) {
	        this.destination.error(err);
	    };
	    SimpleOuterSubscriber.prototype.notifyComplete = function () {
	        this.destination.complete();
	    };
	    return SimpleOuterSubscriber;
	}(Subscriber));
	function innerSubscribe(result, innerSubscriber) {
	    if (innerSubscriber.closed) {
	        return undefined;
	    }
	    if (result instanceof Observable) {
	        return result.subscribe(innerSubscriber);
	    }
	    var subscription;
	    try {
	        subscription = subscribeTo(result)(innerSubscriber);
	    }
	    catch (error) {
	        innerSubscriber.error(error);
	    }
	    return subscription;
	}

	/** PURE_IMPORTS_START tslib,_innerSubscribe PURE_IMPORTS_END */
	function audit(durationSelector) {
	    return function auditOperatorFunction(source) {
	        return source.lift(new AuditOperator(durationSelector));
	    };
	}
	var AuditOperator = /*@__PURE__*/ (function () {
	    function AuditOperator(durationSelector) {
	        this.durationSelector = durationSelector;
	    }
	    AuditOperator.prototype.call = function (subscriber, source) {
	        return source.subscribe(new AuditSubscriber(subscriber, this.durationSelector));
	    };
	    return AuditOperator;
	}());
	var AuditSubscriber = /*@__PURE__*/ (function (_super) {
	    __extends(AuditSubscriber, _super);
	    function AuditSubscriber(destination, durationSelector) {
	        var _this = _super.call(this, destination) || this;
	        _this.durationSelector = durationSelector;
	        _this.hasValue = false;
	        return _this;
	    }
	    AuditSubscriber.prototype._next = function (value) {
	        this.value = value;
	        this.hasValue = true;
	        if (!this.throttled) {
	            var duration = void 0;
	            try {
	                var durationSelector = this.durationSelector;
	                duration = durationSelector(value);
	            }
	            catch (err) {
	                return this.destination.error(err);
	            }
	            var innerSubscription = innerSubscribe(duration, new SimpleInnerSubscriber(this));
	            if (!innerSubscription || innerSubscription.closed) {
	                this.clearThrottle();
	            }
	            else {
	                this.add(this.throttled = innerSubscription);
	            }
	        }
	    };
	    AuditSubscriber.prototype.clearThrottle = function () {
	        var _a = this, value = _a.value, hasValue = _a.hasValue, throttled = _a.throttled;
	        if (throttled) {
	            this.remove(throttled);
	            this.throttled = undefined;
	            throttled.unsubscribe();
	        }
	        if (hasValue) {
	            this.value = undefined;
	            this.hasValue = false;
	            this.destination.next(value);
	        }
	    };
	    AuditSubscriber.prototype.notifyNext = function () {
	        this.clearThrottle();
	    };
	    AuditSubscriber.prototype.notifyComplete = function () {
	        this.clearThrottle();
	    };
	    return AuditSubscriber;
	}(SimpleOuterSubscriber));

	/** PURE_IMPORTS_START _AsyncAction,_AsyncScheduler PURE_IMPORTS_END */
	var asyncScheduler = /*@__PURE__*/ new AsyncScheduler(AsyncAction);
	var async = asyncScheduler;

	/** PURE_IMPORTS_START _isArray PURE_IMPORTS_END */
	function isNumeric(val) {
	    return !isArray(val) && (val - parseFloat(val) + 1) >= 0;
	}

	/** PURE_IMPORTS_START _Observable,_scheduler_async,_util_isNumeric,_util_isScheduler PURE_IMPORTS_END */
	function timer(dueTime, periodOrScheduler, scheduler) {
	    if (dueTime === void 0) {
	        dueTime = 0;
	    }
	    var period = -1;
	    if (isNumeric(periodOrScheduler)) {
	        period = Number(periodOrScheduler) < 1 && 1 || Number(periodOrScheduler);
	    }
	    else if (isScheduler(periodOrScheduler)) {
	        scheduler = periodOrScheduler;
	    }
	    if (!isScheduler(scheduler)) {
	        scheduler = async;
	    }
	    return new Observable(function (subscriber) {
	        var due = isNumeric(dueTime)
	            ? dueTime
	            : (+dueTime - scheduler.now());
	        return scheduler.schedule(dispatch, due, {
	            index: 0, period: period, subscriber: subscriber
	        });
	    });
	}
	function dispatch(state) {
	    var index = state.index, period = state.period, subscriber = state.subscriber;
	    subscriber.next(index);
	    if (subscriber.closed) {
	        return;
	    }
	    else if (period === -1) {
	        return subscriber.complete();
	    }
	    state.index = index + 1;
	    this.schedule(state, period);
	}

	/** PURE_IMPORTS_START _scheduler_async,_audit,_observable_timer PURE_IMPORTS_END */
	function auditTime(duration, scheduler) {
	    if (scheduler === void 0) {
	        scheduler = async;
	    }
	    return audit(function () { return timer(duration, scheduler); });
	}

	/** PURE_IMPORTS_START tslib,_innerSubscribe PURE_IMPORTS_END */
	function buffer(closingNotifier) {
	    return function bufferOperatorFunction(source) {
	        return source.lift(new BufferOperator(closingNotifier));
	    };
	}
	var BufferOperator = /*@__PURE__*/ (function () {
	    function BufferOperator(closingNotifier) {
	        this.closingNotifier = closingNotifier;
	    }
	    BufferOperator.prototype.call = function (subscriber, source) {
	        return source.subscribe(new BufferSubscriber(subscriber, this.closingNotifier));
	    };
	    return BufferOperator;
	}());
	var BufferSubscriber = /*@__PURE__*/ (function (_super) {
	    __extends(BufferSubscriber, _super);
	    function BufferSubscriber(destination, closingNotifier) {
	        var _this = _super.call(this, destination) || this;
	        _this.buffer = [];
	        _this.add(innerSubscribe(closingNotifier, new SimpleInnerSubscriber(_this)));
	        return _this;
	    }
	    BufferSubscriber.prototype._next = function (value) {
	        this.buffer.push(value);
	    };
	    BufferSubscriber.prototype.notifyNext = function () {
	        var buffer = this.buffer;
	        this.buffer = [];
	        this.destination.next(buffer);
	    };
	    return BufferSubscriber;
	}(SimpleOuterSubscriber));

	/** PURE_IMPORTS_START tslib,_Subscriber PURE_IMPORTS_END */
	function bufferCount(bufferSize, startBufferEvery) {
	    if (startBufferEvery === void 0) {
	        startBufferEvery = null;
	    }
	    return function bufferCountOperatorFunction(source) {
	        return source.lift(new BufferCountOperator(bufferSize, startBufferEvery));
	    };
	}
	var BufferCountOperator = /*@__PURE__*/ (function () {
	    function BufferCountOperator(bufferSize, startBufferEvery) {
	        this.bufferSize = bufferSize;
	        this.startBufferEvery = startBufferEvery;
	        if (!startBufferEvery || bufferSize === startBufferEvery) {
	            this.subscriberClass = BufferCountSubscriber;
	        }
	        else {
	            this.subscriberClass = BufferSkipCountSubscriber;
	        }
	    }
	    BufferCountOperator.prototype.call = function (subscriber, source) {
	        return source.subscribe(new this.subscriberClass(subscriber, this.bufferSize, this.startBufferEvery));
	    };
	    return BufferCountOperator;
	}());
	var BufferCountSubscriber = /*@__PURE__*/ (function (_super) {
	    __extends(BufferCountSubscriber, _super);
	    function BufferCountSubscriber(destination, bufferSize) {
	        var _this = _super.call(this, destination) || this;
	        _this.bufferSize = bufferSize;
	        _this.buffer = [];
	        return _this;
	    }
	    BufferCountSubscriber.prototype._next = function (value) {
	        var buffer = this.buffer;
	        buffer.push(value);
	        if (buffer.length == this.bufferSize) {
	            this.destination.next(buffer);
	            this.buffer = [];
	        }
	    };
	    BufferCountSubscriber.prototype._complete = function () {
	        var buffer = this.buffer;
	        if (buffer.length > 0) {
	            this.destination.next(buffer);
	        }
	        _super.prototype._complete.call(this);
	    };
	    return BufferCountSubscriber;
	}(Subscriber));
	var BufferSkipCountSubscriber = /*@__PURE__*/ (function (_super) {
	    __extends(BufferSkipCountSubscriber, _super);
	    function BufferSkipCountSubscriber(destination, bufferSize, startBufferEvery) {
	        var _this = _super.call(this, destination) || this;
	        _this.bufferSize = bufferSize;
	        _this.startBufferEvery = startBufferEvery;
	        _this.buffers = [];
	        _this.count = 0;
	        return _this;
	    }
	    BufferSkipCountSubscriber.prototype._next = function (value) {
	        var _a = this, bufferSize = _a.bufferSize, startBufferEvery = _a.startBufferEvery, buffers = _a.buffers, count = _a.count;
	        this.count++;
	        if (count % startBufferEvery === 0) {
	            buffers.push([]);
	        }
	        for (var i = buffers.length; i--;) {
	            var buffer = buffers[i];
	            buffer.push(value);
	            if (buffer.length === bufferSize) {
	                buffers.splice(i, 1);
	                this.destination.next(buffer);
	            }
	        }
	    };
	    BufferSkipCountSubscriber.prototype._complete = function () {
	        var _a = this, buffers = _a.buffers, destination = _a.destination;
	        while (buffers.length > 0) {
	            var buffer = buffers.shift();
	            if (buffer.length > 0) {
	                destination.next(buffer);
	            }
	        }
	        _super.prototype._complete.call(this);
	    };
	    return BufferSkipCountSubscriber;
	}(Subscriber));

	/** PURE_IMPORTS_START tslib,_scheduler_async,_Subscriber,_util_isScheduler PURE_IMPORTS_END */
	function bufferTime(bufferTimeSpan) {
	    var length = arguments.length;
	    var scheduler = async;
	    if (isScheduler(arguments[arguments.length - 1])) {
	        scheduler = arguments[arguments.length - 1];
	        length--;
	    }
	    var bufferCreationInterval = null;
	    if (length >= 2) {
	        bufferCreationInterval = arguments[1];
	    }
	    var maxBufferSize = Number.POSITIVE_INFINITY;
	    if (length >= 3) {
	        maxBufferSize = arguments[2];
	    }
	    return function bufferTimeOperatorFunction(source) {
	        return source.lift(new BufferTimeOperator(bufferTimeSpan, bufferCreationInterval, maxBufferSize, scheduler));
	    };
	}
	var BufferTimeOperator = /*@__PURE__*/ (function () {
	    function BufferTimeOperator(bufferTimeSpan, bufferCreationInterval, maxBufferSize, scheduler) {
	        this.bufferTimeSpan = bufferTimeSpan;
	        this.bufferCreationInterval = bufferCreationInterval;
	        this.maxBufferSize = maxBufferSize;
	        this.scheduler = scheduler;
	    }
	    BufferTimeOperator.prototype.call = function (subscriber, source) {
	        return source.subscribe(new BufferTimeSubscriber(subscriber, this.bufferTimeSpan, this.bufferCreationInterval, this.maxBufferSize, this.scheduler));
	    };
	    return BufferTimeOperator;
	}());
	var Context = /*@__PURE__*/ (function () {
	    function Context() {
	        this.buffer = [];
	    }
	    return Context;
	}());
	var BufferTimeSubscriber = /*@__PURE__*/ (function (_super) {
	    __extends(BufferTimeSubscriber, _super);
	    function BufferTimeSubscriber(destination, bufferTimeSpan, bufferCreationInterval, maxBufferSize, scheduler) {
	        var _this = _super.call(this, destination) || this;
	        _this.bufferTimeSpan = bufferTimeSpan;
	        _this.bufferCreationInterval = bufferCreationInterval;
	        _this.maxBufferSize = maxBufferSize;
	        _this.scheduler = scheduler;
	        _this.contexts = [];
	        var context = _this.openContext();
	        _this.timespanOnly = bufferCreationInterval == null || bufferCreationInterval < 0;
	        if (_this.timespanOnly) {
	            var timeSpanOnlyState = { subscriber: _this, context: context, bufferTimeSpan: bufferTimeSpan };
	            _this.add(context.closeAction = scheduler.schedule(dispatchBufferTimeSpanOnly, bufferTimeSpan, timeSpanOnlyState));
	        }
	        else {
	            var closeState = { subscriber: _this, context: context };
	            var creationState = { bufferTimeSpan: bufferTimeSpan, bufferCreationInterval: bufferCreationInterval, subscriber: _this, scheduler: scheduler };
	            _this.add(context.closeAction = scheduler.schedule(dispatchBufferClose, bufferTimeSpan, closeState));
	            _this.add(scheduler.schedule(dispatchBufferCreation, bufferCreationInterval, creationState));
	        }
	        return _this;
	    }
	    BufferTimeSubscriber.prototype._next = function (value) {
	        var contexts = this.contexts;
	        var len = contexts.length;
	        var filledBufferContext;
	        for (var i = 0; i < len; i++) {
	            var context_1 = contexts[i];
	            var buffer = context_1.buffer;
	            buffer.push(value);
	            if (buffer.length == this.maxBufferSize) {
	                filledBufferContext = context_1;
	            }
	        }
	        if (filledBufferContext) {
	            this.onBufferFull(filledBufferContext);
	        }
	    };
	    BufferTimeSubscriber.prototype._error = function (err) {
	        this.contexts.length = 0;
	        _super.prototype._error.call(this, err);
	    };
	    BufferTimeSubscriber.prototype._complete = function () {
	        var _a = this, contexts = _a.contexts, destination = _a.destination;
	        while (contexts.length > 0) {
	            var context_2 = contexts.shift();
	            destination.next(context_2.buffer);
	        }
	        _super.prototype._complete.call(this);
	    };
	    BufferTimeSubscriber.prototype._unsubscribe = function () {
	        this.contexts = null;
	    };
	    BufferTimeSubscriber.prototype.onBufferFull = function (context) {
	        this.closeContext(context);
	        var closeAction = context.closeAction;
	        closeAction.unsubscribe();
	        this.remove(closeAction);
	        if (!this.closed && this.timespanOnly) {
	            context = this.openContext();
	            var bufferTimeSpan = this.bufferTimeSpan;
	            var timeSpanOnlyState = { subscriber: this, context: context, bufferTimeSpan: bufferTimeSpan };
	            this.add(context.closeAction = this.scheduler.schedule(dispatchBufferTimeSpanOnly, bufferTimeSpan, timeSpanOnlyState));
	        }
	    };
	    BufferTimeSubscriber.prototype.openContext = function () {
	        var context = new Context();
	        this.contexts.push(context);
	        return context;
	    };
	    BufferTimeSubscriber.prototype.closeContext = function (context) {
	        this.destination.next(context.buffer);
	        var contexts = this.contexts;
	        var spliceIndex = contexts ? contexts.indexOf(context) : -1;
	        if (spliceIndex >= 0) {
	            contexts.splice(contexts.indexOf(context), 1);
	        }
	    };
	    return BufferTimeSubscriber;
	}(Subscriber));
	function dispatchBufferTimeSpanOnly(state) {
	    var subscriber = state.subscriber;
	    var prevContext = state.context;
	    if (prevContext) {
	        subscriber.closeContext(prevContext);
	    }
	    if (!subscriber.closed) {
	        state.context = subscriber.openContext();
	        state.context.closeAction = this.schedule(state, state.bufferTimeSpan);
	    }
	}
	function dispatchBufferCreation(state) {
	    var bufferCreationInterval = state.bufferCreationInterval, bufferTimeSpan = state.bufferTimeSpan, subscriber = state.subscriber, scheduler = state.scheduler;
	    var context = subscriber.openContext();
	    var action = this;
	    if (!subscriber.closed) {
	        subscriber.add(context.closeAction = scheduler.schedule(dispatchBufferClose, bufferTimeSpan, { subscriber: subscriber, context: context }));
	        action.schedule(state, bufferCreationInterval);
	    }
	}
	function dispatchBufferClose(arg) {
	    var subscriber = arg.subscriber, context = arg.context;
	    subscriber.closeContext(context);
	}

	/** PURE_IMPORTS_START tslib,_Subscriber PURE_IMPORTS_END */
	var InnerSubscriber = /*@__PURE__*/ (function (_super) {
	    __extends(InnerSubscriber, _super);
	    function InnerSubscriber(parent, outerValue, outerIndex) {
	        var _this = _super.call(this) || this;
	        _this.parent = parent;
	        _this.outerValue = outerValue;
	        _this.outerIndex = outerIndex;
	        _this.index = 0;
	        return _this;
	    }
	    InnerSubscriber.prototype._next = function (value) {
	        this.parent.notifyNext(this.outerValue, value, this.outerIndex, this.index++, this);
	    };
	    InnerSubscriber.prototype._error = function (error) {
	        this.parent.notifyError(error, this);
	        this.unsubscribe();
	    };
	    InnerSubscriber.prototype._complete = function () {
	        this.parent.notifyComplete(this);
	        this.unsubscribe();
	    };
	    return InnerSubscriber;
	}(Subscriber));

	/** PURE_IMPORTS_START _InnerSubscriber,_subscribeTo,_Observable PURE_IMPORTS_END */
	function subscribeToResult(outerSubscriber, result, outerValue, outerIndex, innerSubscriber) {
	    {
	        innerSubscriber = new InnerSubscriber(outerSubscriber, outerValue, outerIndex);
	    }
	    if (innerSubscriber.closed) ;
	    if (result instanceof Observable) {
	        return result.subscribe(innerSubscriber);
	    }
	    return subscribeTo(result)(innerSubscriber);
	}

	/** PURE_IMPORTS_START tslib,_Subscriber PURE_IMPORTS_END */
	var OuterSubscriber = /*@__PURE__*/ (function (_super) {
	    __extends(OuterSubscriber, _super);
	    function OuterSubscriber() {
	        return _super !== null && _super.apply(this, arguments) || this;
	    }
	    OuterSubscriber.prototype.notifyNext = function (outerValue, innerValue, outerIndex, innerIndex, innerSub) {
	        this.destination.next(innerValue);
	    };
	    OuterSubscriber.prototype.notifyError = function (error, innerSub) {
	        this.destination.error(error);
	    };
	    OuterSubscriber.prototype.notifyComplete = function (innerSub) {
	        this.destination.complete();
	    };
	    return OuterSubscriber;
	}(Subscriber));

	/** PURE_IMPORTS_START tslib,_Subscription,_util_subscribeToResult,_OuterSubscriber PURE_IMPORTS_END */
	function bufferToggle(openings, closingSelector) {
	    return function bufferToggleOperatorFunction(source) {
	        return source.lift(new BufferToggleOperator(openings, closingSelector));
	    };
	}
	var BufferToggleOperator = /*@__PURE__*/ (function () {
	    function BufferToggleOperator(openings, closingSelector) {
	        this.openings = openings;
	        this.closingSelector = closingSelector;
	    }
	    BufferToggleOperator.prototype.call = function (subscriber, source) {
	        return source.subscribe(new BufferToggleSubscriber(subscriber, this.openings, this.closingSelector));
	    };
	    return BufferToggleOperator;
	}());
	var BufferToggleSubscriber = /*@__PURE__*/ (function (_super) {
	    __extends(BufferToggleSubscriber, _super);
	    function BufferToggleSubscriber(destination, openings, closingSelector) {
	        var _this = _super.call(this, destination) || this;
	        _this.closingSelector = closingSelector;
	        _this.contexts = [];
	        _this.add(subscribeToResult(_this, openings));
	        return _this;
	    }
	    BufferToggleSubscriber.prototype._next = function (value) {
	        var contexts = this.contexts;
	        var len = contexts.length;
	        for (var i = 0; i < len; i++) {
	            contexts[i].buffer.push(value);
	        }
	    };
	    BufferToggleSubscriber.prototype._error = function (err) {
	        var contexts = this.contexts;
	        while (contexts.length > 0) {
	            var context_1 = contexts.shift();
	            context_1.subscription.unsubscribe();
	            context_1.buffer = null;
	            context_1.subscription = null;
	        }
	        this.contexts = null;
	        _super.prototype._error.call(this, err);
	    };
	    BufferToggleSubscriber.prototype._complete = function () {
	        var contexts = this.contexts;
	        while (contexts.length > 0) {
	            var context_2 = contexts.shift();
	            this.destination.next(context_2.buffer);
	            context_2.subscription.unsubscribe();
	            context_2.buffer = null;
	            context_2.subscription = null;
	        }
	        this.contexts = null;
	        _super.prototype._complete.call(this);
	    };
	    BufferToggleSubscriber.prototype.notifyNext = function (outerValue, innerValue) {
	        outerValue ? this.closeBuffer(outerValue) : this.openBuffer(innerValue);
	    };
	    BufferToggleSubscriber.prototype.notifyComplete = function (innerSub) {
	        this.closeBuffer(innerSub.context);
	    };
	    BufferToggleSubscriber.prototype.openBuffer = function (value) {
	        try {
	            var closingSelector = this.closingSelector;
	            var closingNotifier = closingSelector.call(this, value);
	            if (closingNotifier) {
	                this.trySubscribe(closingNotifier);
	            }
	        }
	        catch (err) {
	            this._error(err);
	        }
	    };
	    BufferToggleSubscriber.prototype.closeBuffer = function (context) {
	        var contexts = this.contexts;
	        if (contexts && context) {
	            var buffer = context.buffer, subscription = context.subscription;
	            this.destination.next(buffer);
	            contexts.splice(contexts.indexOf(context), 1);
	            this.remove(subscription);
	            subscription.unsubscribe();
	        }
	    };
	    BufferToggleSubscriber.prototype.trySubscribe = function (closingNotifier) {
	        var contexts = this.contexts;
	        var buffer = [];
	        var subscription = new Subscription();
	        var context = { buffer: buffer, subscription: subscription };
	        contexts.push(context);
	        var innerSubscription = subscribeToResult(this, closingNotifier, context);
	        if (!innerSubscription || innerSubscription.closed) {
	            this.closeBuffer(context);
	        }
	        else {
	            innerSubscription.context = context;
	            this.add(innerSubscription);
	            subscription.add(innerSubscription);
	        }
	    };
	    return BufferToggleSubscriber;
	}(OuterSubscriber));

	/** PURE_IMPORTS_START tslib,_Subscription,_innerSubscribe PURE_IMPORTS_END */
	function bufferWhen(closingSelector) {
	    return function (source) {
	        return source.lift(new BufferWhenOperator(closingSelector));
	    };
	}
	var BufferWhenOperator = /*@__PURE__*/ (function () {
	    function BufferWhenOperator(closingSelector) {
	        this.closingSelector = closingSelector;
	    }
	    BufferWhenOperator.prototype.call = function (subscriber, source) {
	        return source.subscribe(new BufferWhenSubscriber(subscriber, this.closingSelector));
	    };
	    return BufferWhenOperator;
	}());
	var BufferWhenSubscriber = /*@__PURE__*/ (function (_super) {
	    __extends(BufferWhenSubscriber, _super);
	    function BufferWhenSubscriber(destination, closingSelector) {
	        var _this = _super.call(this, destination) || this;
	        _this.closingSelector = closingSelector;
	        _this.subscribing = false;
	        _this.openBuffer();
	        return _this;
	    }
	    BufferWhenSubscriber.prototype._next = function (value) {
	        this.buffer.push(value);
	    };
	    BufferWhenSubscriber.prototype._complete = function () {
	        var buffer = this.buffer;
	        if (buffer) {
	            this.destination.next(buffer);
	        }
	        _super.prototype._complete.call(this);
	    };
	    BufferWhenSubscriber.prototype._unsubscribe = function () {
	        this.buffer = undefined;
	        this.subscribing = false;
	    };
	    BufferWhenSubscriber.prototype.notifyNext = function () {
	        this.openBuffer();
	    };
	    BufferWhenSubscriber.prototype.notifyComplete = function () {
	        if (this.subscribing) {
	            this.complete();
	        }
	        else {
	            this.openBuffer();
	        }
	    };
	    BufferWhenSubscriber.prototype.openBuffer = function () {
	        var closingSubscription = this.closingSubscription;
	        if (closingSubscription) {
	            this.remove(closingSubscription);
	            closingSubscription.unsubscribe();
	        }
	        var buffer = this.buffer;
	        if (this.buffer) {
	            this.destination.next(buffer);
	        }
	        this.buffer = [];
	        var closingNotifier;
	        try {
	            var closingSelector = this.closingSelector;
	            closingNotifier = closingSelector();
	        }
	        catch (err) {
	            return this.error(err);
	        }
	        closingSubscription = new Subscription();
	        this.closingSubscription = closingSubscription;
	        this.add(closingSubscription);
	        this.subscribing = true;
	        closingSubscription.add(innerSubscribe(closingNotifier, new SimpleInnerSubscriber(this)));
	        this.subscribing = false;
	    };
	    return BufferWhenSubscriber;
	}(SimpleOuterSubscriber));

	/** PURE_IMPORTS_START tslib,_innerSubscribe PURE_IMPORTS_END */
	function catchError(selector) {
	    return function catchErrorOperatorFunction(source) {
	        var operator = new CatchOperator(selector);
	        var caught = source.lift(operator);
	        return (operator.caught = caught);
	    };
	}
	var CatchOperator = /*@__PURE__*/ (function () {
	    function CatchOperator(selector) {
	        this.selector = selector;
	    }
	    CatchOperator.prototype.call = function (subscriber, source) {
	        return source.subscribe(new CatchSubscriber(subscriber, this.selector, this.caught));
	    };
	    return CatchOperator;
	}());
	var CatchSubscriber = /*@__PURE__*/ (function (_super) {
	    __extends(CatchSubscriber, _super);
	    function CatchSubscriber(destination, selector, caught) {
	        var _this = _super.call(this, destination) || this;
	        _this.selector = selector;
	        _this.caught = caught;
	        return _this;
	    }
	    CatchSubscriber.prototype.error = function (err) {
	        if (!this.isStopped) {
	            var result = void 0;
	            try {
	                result = this.selector(err, this.caught);
	            }
	            catch (err2) {
	                _super.prototype.error.call(this, err2);
	                return;
	            }
	            this._unsubscribeAndRecycle();
	            var innerSubscriber = new SimpleInnerSubscriber(this);
	            this.add(innerSubscriber);
	            var innerSubscription = innerSubscribe(result, innerSubscriber);
	            if (innerSubscription !== innerSubscriber) {
	                this.add(innerSubscription);
	            }
	        }
	    };
	    return CatchSubscriber;
	}(SimpleOuterSubscriber));

	/** PURE_IMPORTS_START tslib,_util_isScheduler,_util_isArray,_OuterSubscriber,_util_subscribeToResult,_fromArray PURE_IMPORTS_END */
	var NONE = {};
	var CombineLatestOperator = /*@__PURE__*/ (function () {
	    function CombineLatestOperator(resultSelector) {
	        this.resultSelector = resultSelector;
	    }
	    CombineLatestOperator.prototype.call = function (subscriber, source) {
	        return source.subscribe(new CombineLatestSubscriber(subscriber, this.resultSelector));
	    };
	    return CombineLatestOperator;
	}());
	var CombineLatestSubscriber = /*@__PURE__*/ (function (_super) {
	    __extends(CombineLatestSubscriber, _super);
	    function CombineLatestSubscriber(destination, resultSelector) {
	        var _this = _super.call(this, destination) || this;
	        _this.resultSelector = resultSelector;
	        _this.active = 0;
	        _this.values = [];
	        _this.observables = [];
	        return _this;
	    }
	    CombineLatestSubscriber.prototype._next = function (observable) {
	        this.values.push(NONE);
	        this.observables.push(observable);
	    };
	    CombineLatestSubscriber.prototype._complete = function () {
	        var observables = this.observables;
	        var len = observables.length;
	        if (len === 0) {
	            this.destination.complete();
	        }
	        else {
	            this.active = len;
	            this.toRespond = len;
	            for (var i = 0; i < len; i++) {
	                var observable = observables[i];
	                this.add(subscribeToResult(this, observable, undefined, i));
	            }
	        }
	    };
	    CombineLatestSubscriber.prototype.notifyComplete = function (unused) {
	        if ((this.active -= 1) === 0) {
	            this.destination.complete();
	        }
	    };
	    CombineLatestSubscriber.prototype.notifyNext = function (_outerValue, innerValue, outerIndex) {
	        var values = this.values;
	        var oldVal = values[outerIndex];
	        var toRespond = !this.toRespond
	            ? 0
	            : oldVal === NONE ? --this.toRespond : this.toRespond;
	        values[outerIndex] = innerValue;
	        if (toRespond === 0) {
	            if (this.resultSelector) {
	                this._tryResultSelector(values);
	            }
	            else {
	                this.destination.next(values.slice());
	            }
	        }
	    };
	    CombineLatestSubscriber.prototype._tryResultSelector = function (values) {
	        var result;
	        try {
	            result = this.resultSelector.apply(this, values);
	        }
	        catch (err) {
	            this.destination.error(err);
	            return;
	        }
	        this.destination.next(result);
	    };
	    return CombineLatestSubscriber;
	}(OuterSubscriber));

	/** PURE_IMPORTS_START _observable_combineLatest PURE_IMPORTS_END */
	function combineAll(project) {
	    return function (source) { return source.lift(new CombineLatestOperator(project)); };
	}

	/** PURE_IMPORTS_START _Observable,_util_subscribeTo,_scheduled_scheduled PURE_IMPORTS_END */
	function from(input, scheduler) {
	    {
	        if (input instanceof Observable) {
	            return input;
	        }
	        return new Observable(subscribeTo(input));
	    }
	}

	/** PURE_IMPORTS_START _util_isArray,_observable_combineLatest,_observable_from PURE_IMPORTS_END */
	function combineLatest() {
	    var observables = [];
	    for (var _i = 0; _i < arguments.length; _i++) {
	        observables[_i] = arguments[_i];
	    }
	    var project = null;
	    if (typeof observables[observables.length - 1] === 'function') {
	        project = observables.pop();
	    }
	    if (observables.length === 1 && isArray(observables[0])) {
	        observables = observables[0].slice();
	    }
	    return function (source) { return source.lift.call(from([source].concat(observables)), new CombineLatestOperator(project)); };
	}

	/** PURE_IMPORTS_START tslib,_Subscriber PURE_IMPORTS_END */
	function map(project, thisArg) {
	    return function mapOperation(source) {
	        if (typeof project !== 'function') {
	            throw new TypeError('argument is not a function. Are you looking for `mapTo()`?');
	        }
	        return source.lift(new MapOperator(project, thisArg));
	    };
	}
	var MapOperator = /*@__PURE__*/ (function () {
	    function MapOperator(project, thisArg) {
	        this.project = project;
	        this.thisArg = thisArg;
	    }
	    MapOperator.prototype.call = function (subscriber, source) {
	        return source.subscribe(new MapSubscriber(subscriber, this.project, this.thisArg));
	    };
	    return MapOperator;
	}());
	var MapSubscriber = /*@__PURE__*/ (function (_super) {
	    __extends(MapSubscriber, _super);
	    function MapSubscriber(destination, project, thisArg) {
	        var _this = _super.call(this, destination) || this;
	        _this.project = project;
	        _this.count = 0;
	        _this.thisArg = thisArg || _this;
	        return _this;
	    }
	    MapSubscriber.prototype._next = function (value) {
	        var result;
	        try {
	            result = this.project.call(this.thisArg, value, this.count++);
	        }
	        catch (err) {
	            this.destination.error(err);
	            return;
	        }
	        this.destination.next(result);
	    };
	    return MapSubscriber;
	}(Subscriber));

	/** PURE_IMPORTS_START tslib,_map,_observable_from,_innerSubscribe PURE_IMPORTS_END */
	function mergeMap(project, resultSelector, concurrent) {
	    if (concurrent === void 0) {
	        concurrent = Number.POSITIVE_INFINITY;
	    }
	    if (typeof resultSelector === 'function') {
	        return function (source) { return source.pipe(mergeMap(function (a, i) { return from(project(a, i)).pipe(map(function (b, ii) { return resultSelector(a, b, i, ii); })); }, concurrent)); };
	    }
	    else if (typeof resultSelector === 'number') {
	        concurrent = resultSelector;
	    }
	    return function (source) { return source.lift(new MergeMapOperator(project, concurrent)); };
	}
	var MergeMapOperator = /*@__PURE__*/ (function () {
	    function MergeMapOperator(project, concurrent) {
	        if (concurrent === void 0) {
	            concurrent = Number.POSITIVE_INFINITY;
	        }
	        this.project = project;
	        this.concurrent = concurrent;
	    }
	    MergeMapOperator.prototype.call = function (observer, source) {
	        return source.subscribe(new MergeMapSubscriber(observer, this.project, this.concurrent));
	    };
	    return MergeMapOperator;
	}());
	var MergeMapSubscriber = /*@__PURE__*/ (function (_super) {
	    __extends(MergeMapSubscriber, _super);
	    function MergeMapSubscriber(destination, project, concurrent) {
	        if (concurrent === void 0) {
	            concurrent = Number.POSITIVE_INFINITY;
	        }
	        var _this = _super.call(this, destination) || this;
	        _this.project = project;
	        _this.concurrent = concurrent;
	        _this.hasCompleted = false;
	        _this.buffer = [];
	        _this.active = 0;
	        _this.index = 0;
	        return _this;
	    }
	    MergeMapSubscriber.prototype._next = function (value) {
	        if (this.active < this.concurrent) {
	            this._tryNext(value);
	        }
	        else {
	            this.buffer.push(value);
	        }
	    };
	    MergeMapSubscriber.prototype._tryNext = function (value) {
	        var result;
	        var index = this.index++;
	        try {
	            result = this.project(value, index);
	        }
	        catch (err) {
	            this.destination.error(err);
	            return;
	        }
	        this.active++;
	        this._innerSub(result);
	    };
	    MergeMapSubscriber.prototype._innerSub = function (ish) {
	        var innerSubscriber = new SimpleInnerSubscriber(this);
	        var destination = this.destination;
	        destination.add(innerSubscriber);
	        var innerSubscription = innerSubscribe(ish, innerSubscriber);
	        if (innerSubscription !== innerSubscriber) {
	            destination.add(innerSubscription);
	        }
	    };
	    MergeMapSubscriber.prototype._complete = function () {
	        this.hasCompleted = true;
	        if (this.active === 0 && this.buffer.length === 0) {
	            this.destination.complete();
	        }
	        this.unsubscribe();
	    };
	    MergeMapSubscriber.prototype.notifyNext = function (innerValue) {
	        this.destination.next(innerValue);
	    };
	    MergeMapSubscriber.prototype.notifyComplete = function () {
	        var buffer = this.buffer;
	        this.active--;
	        if (buffer.length > 0) {
	            this._next(buffer.shift());
	        }
	        else if (this.active === 0 && this.hasCompleted) {
	            this.destination.complete();
	        }
	    };
	    return MergeMapSubscriber;
	}(SimpleOuterSubscriber));
	var flatMap = mergeMap;

	/** PURE_IMPORTS_START _mergeMap,_util_identity PURE_IMPORTS_END */
	function mergeAll(concurrent) {
	    if (concurrent === void 0) {
	        concurrent = Number.POSITIVE_INFINITY;
	    }
	    return mergeMap(identity, concurrent);
	}

	/** PURE_IMPORTS_START _mergeAll PURE_IMPORTS_END */
	function concatAll() {
	    return mergeAll(1);
	}

	/** PURE_IMPORTS_START _of,_operators_concatAll PURE_IMPORTS_END */
	function concat$1() {
	    var observables = [];
	    for (var _i = 0; _i < arguments.length; _i++) {
	        observables[_i] = arguments[_i];
	    }
	    return concatAll()(of.apply(void 0, observables));
	}

	/** PURE_IMPORTS_START _observable_concat PURE_IMPORTS_END */
	function concat() {
	    var observables = [];
	    for (var _i = 0; _i < arguments.length; _i++) {
	        observables[_i] = arguments[_i];
	    }
	    return function (source) { return source.lift.call(concat$1.apply(void 0, [source].concat(observables))); };
	}

	/** PURE_IMPORTS_START _mergeMap PURE_IMPORTS_END */
	function concatMap(project, resultSelector) {
	    return mergeMap(project, resultSelector, 1);
	}

	/** PURE_IMPORTS_START _concatMap PURE_IMPORTS_END */
	function concatMapTo(innerObservable, resultSelector) {
	    return concatMap(function () { return innerObservable; }, resultSelector);
	}

	/** PURE_IMPORTS_START tslib,_Subscriber PURE_IMPORTS_END */
	function count(predicate) {
	    return function (source) { return source.lift(new CountOperator(predicate, source)); };
	}
	var CountOperator = /*@__PURE__*/ (function () {
	    function CountOperator(predicate, source) {
	        this.predicate = predicate;
	        this.source = source;
	    }
	    CountOperator.prototype.call = function (subscriber, source) {
	        return source.subscribe(new CountSubscriber(subscriber, this.predicate, this.source));
	    };
	    return CountOperator;
	}());
	var CountSubscriber = /*@__PURE__*/ (function (_super) {
	    __extends(CountSubscriber, _super);
	    function CountSubscriber(destination, predicate, source) {
	        var _this = _super.call(this, destination) || this;
	        _this.predicate = predicate;
	        _this.source = source;
	        _this.count = 0;
	        _this.index = 0;
	        return _this;
	    }
	    CountSubscriber.prototype._next = function (value) {
	        if (this.predicate) {
	            this._tryPredicate(value);
	        }
	        else {
	            this.count++;
	        }
	    };
	    CountSubscriber.prototype._tryPredicate = function (value) {
	        var result;
	        try {
	            result = this.predicate(value, this.index++, this.source);
	        }
	        catch (err) {
	            this.destination.error(err);
	            return;
	        }
	        if (result) {
	            this.count++;
	        }
	    };
	    CountSubscriber.prototype._complete = function () {
	        this.destination.next(this.count);
	        this.destination.complete();
	    };
	    return CountSubscriber;
	}(Subscriber));

	/** PURE_IMPORTS_START tslib,_innerSubscribe PURE_IMPORTS_END */
	function debounce(durationSelector) {
	    return function (source) { return source.lift(new DebounceOperator(durationSelector)); };
	}
	var DebounceOperator = /*@__PURE__*/ (function () {
	    function DebounceOperator(durationSelector) {
	        this.durationSelector = durationSelector;
	    }
	    DebounceOperator.prototype.call = function (subscriber, source) {
	        return source.subscribe(new DebounceSubscriber(subscriber, this.durationSelector));
	    };
	    return DebounceOperator;
	}());
	var DebounceSubscriber = /*@__PURE__*/ (function (_super) {
	    __extends(DebounceSubscriber, _super);
	    function DebounceSubscriber(destination, durationSelector) {
	        var _this = _super.call(this, destination) || this;
	        _this.durationSelector = durationSelector;
	        _this.hasValue = false;
	        return _this;
	    }
	    DebounceSubscriber.prototype._next = function (value) {
	        try {
	            var result = this.durationSelector.call(this, value);
	            if (result) {
	                this._tryNext(value, result);
	            }
	        }
	        catch (err) {
	            this.destination.error(err);
	        }
	    };
	    DebounceSubscriber.prototype._complete = function () {
	        this.emitValue();
	        this.destination.complete();
	    };
	    DebounceSubscriber.prototype._tryNext = function (value, duration) {
	        var subscription = this.durationSubscription;
	        this.value = value;
	        this.hasValue = true;
	        if (subscription) {
	            subscription.unsubscribe();
	            this.remove(subscription);
	        }
	        subscription = innerSubscribe(duration, new SimpleInnerSubscriber(this));
	        if (subscription && !subscription.closed) {
	            this.add(this.durationSubscription = subscription);
	        }
	    };
	    DebounceSubscriber.prototype.notifyNext = function () {
	        this.emitValue();
	    };
	    DebounceSubscriber.prototype.notifyComplete = function () {
	        this.emitValue();
	    };
	    DebounceSubscriber.prototype.emitValue = function () {
	        if (this.hasValue) {
	            var value = this.value;
	            var subscription = this.durationSubscription;
	            if (subscription) {
	                this.durationSubscription = undefined;
	                subscription.unsubscribe();
	                this.remove(subscription);
	            }
	            this.value = undefined;
	            this.hasValue = false;
	            _super.prototype._next.call(this, value);
	        }
	    };
	    return DebounceSubscriber;
	}(SimpleOuterSubscriber));

	/** PURE_IMPORTS_START tslib,_Subscriber,_scheduler_async PURE_IMPORTS_END */
	function debounceTime(dueTime, scheduler) {
	    if (scheduler === void 0) {
	        scheduler = async;
	    }
	    return function (source) { return source.lift(new DebounceTimeOperator(dueTime, scheduler)); };
	}
	var DebounceTimeOperator = /*@__PURE__*/ (function () {
	    function DebounceTimeOperator(dueTime, scheduler) {
	        this.dueTime = dueTime;
	        this.scheduler = scheduler;
	    }
	    DebounceTimeOperator.prototype.call = function (subscriber, source) {
	        return source.subscribe(new DebounceTimeSubscriber(subscriber, this.dueTime, this.scheduler));
	    };
	    return DebounceTimeOperator;
	}());
	var DebounceTimeSubscriber = /*@__PURE__*/ (function (_super) {
	    __extends(DebounceTimeSubscriber, _super);
	    function DebounceTimeSubscriber(destination, dueTime, scheduler) {
	        var _this = _super.call(this, destination) || this;
	        _this.dueTime = dueTime;
	        _this.scheduler = scheduler;
	        _this.debouncedSubscription = null;
	        _this.lastValue = null;
	        _this.hasValue = false;
	        return _this;
	    }
	    DebounceTimeSubscriber.prototype._next = function (value) {
	        this.clearDebounce();
	        this.lastValue = value;
	        this.hasValue = true;
	        this.add(this.debouncedSubscription = this.scheduler.schedule(dispatchNext$1, this.dueTime, this));
	    };
	    DebounceTimeSubscriber.prototype._complete = function () {
	        this.debouncedNext();
	        this.destination.complete();
	    };
	    DebounceTimeSubscriber.prototype.debouncedNext = function () {
	        this.clearDebounce();
	        if (this.hasValue) {
	            var lastValue = this.lastValue;
	            this.lastValue = null;
	            this.hasValue = false;
	            this.destination.next(lastValue);
	        }
	    };
	    DebounceTimeSubscriber.prototype.clearDebounce = function () {
	        var debouncedSubscription = this.debouncedSubscription;
	        if (debouncedSubscription !== null) {
	            this.remove(debouncedSubscription);
	            debouncedSubscription.unsubscribe();
	            this.debouncedSubscription = null;
	        }
	    };
	    return DebounceTimeSubscriber;
	}(Subscriber));
	function dispatchNext$1(subscriber) {
	    subscriber.debouncedNext();
	}

	/** PURE_IMPORTS_START tslib,_Subscriber PURE_IMPORTS_END */
	function defaultIfEmpty(defaultValue) {
	    if (defaultValue === void 0) {
	        defaultValue = null;
	    }
	    return function (source) { return source.lift(new DefaultIfEmptyOperator(defaultValue)); };
	}
	var DefaultIfEmptyOperator = /*@__PURE__*/ (function () {
	    function DefaultIfEmptyOperator(defaultValue) {
	        this.defaultValue = defaultValue;
	    }
	    DefaultIfEmptyOperator.prototype.call = function (subscriber, source) {
	        return source.subscribe(new DefaultIfEmptySubscriber(subscriber, this.defaultValue));
	    };
	    return DefaultIfEmptyOperator;
	}());
	var DefaultIfEmptySubscriber = /*@__PURE__*/ (function (_super) {
	    __extends(DefaultIfEmptySubscriber, _super);
	    function DefaultIfEmptySubscriber(destination, defaultValue) {
	        var _this = _super.call(this, destination) || this;
	        _this.defaultValue = defaultValue;
	        _this.isEmpty = true;
	        return _this;
	    }
	    DefaultIfEmptySubscriber.prototype._next = function (value) {
	        this.isEmpty = false;
	        this.destination.next(value);
	    };
	    DefaultIfEmptySubscriber.prototype._complete = function () {
	        if (this.isEmpty) {
	            this.destination.next(this.defaultValue);
	        }
	        this.destination.complete();
	    };
	    return DefaultIfEmptySubscriber;
	}(Subscriber));

	/** PURE_IMPORTS_START  PURE_IMPORTS_END */
	function isDate(value) {
	    return value instanceof Date && !isNaN(+value);
	}

	/** PURE_IMPORTS_START tslib,_scheduler_async,_util_isDate,_Subscriber,_Notification PURE_IMPORTS_END */
	function delay(delay, scheduler) {
	    if (scheduler === void 0) {
	        scheduler = async;
	    }
	    var absoluteDelay = isDate(delay);
	    var delayFor = absoluteDelay ? (+delay - scheduler.now()) : Math.abs(delay);
	    return function (source) { return source.lift(new DelayOperator(delayFor, scheduler)); };
	}
	var DelayOperator = /*@__PURE__*/ (function () {
	    function DelayOperator(delay, scheduler) {
	        this.delay = delay;
	        this.scheduler = scheduler;
	    }
	    DelayOperator.prototype.call = function (subscriber, source) {
	        return source.subscribe(new DelaySubscriber(subscriber, this.delay, this.scheduler));
	    };
	    return DelayOperator;
	}());
	var DelaySubscriber = /*@__PURE__*/ (function (_super) {
	    __extends(DelaySubscriber, _super);
	    function DelaySubscriber(destination, delay, scheduler) {
	        var _this = _super.call(this, destination) || this;
	        _this.delay = delay;
	        _this.scheduler = scheduler;
	        _this.queue = [];
	        _this.active = false;
	        _this.errored = false;
	        return _this;
	    }
	    DelaySubscriber.dispatch = function (state) {
	        var source = state.source;
	        var queue = source.queue;
	        var scheduler = state.scheduler;
	        var destination = state.destination;
	        while (queue.length > 0 && (queue[0].time - scheduler.now()) <= 0) {
	            queue.shift().notification.observe(destination);
	        }
	        if (queue.length > 0) {
	            var delay_1 = Math.max(0, queue[0].time - scheduler.now());
	            this.schedule(state, delay_1);
	        }
	        else {
	            this.unsubscribe();
	            source.active = false;
	        }
	    };
	    DelaySubscriber.prototype._schedule = function (scheduler) {
	        this.active = true;
	        var destination = this.destination;
	        destination.add(scheduler.schedule(DelaySubscriber.dispatch, this.delay, {
	            source: this, destination: this.destination, scheduler: scheduler
	        }));
	    };
	    DelaySubscriber.prototype.scheduleNotification = function (notification) {
	        if (this.errored === true) {
	            return;
	        }
	        var scheduler = this.scheduler;
	        var message = new DelayMessage(scheduler.now() + this.delay, notification);
	        this.queue.push(message);
	        if (this.active === false) {
	            this._schedule(scheduler);
	        }
	    };
	    DelaySubscriber.prototype._next = function (value) {
	        this.scheduleNotification(Notification.createNext(value));
	    };
	    DelaySubscriber.prototype._error = function (err) {
	        this.errored = true;
	        this.queue = [];
	        this.destination.error(err);
	        this.unsubscribe();
	    };
	    DelaySubscriber.prototype._complete = function () {
	        this.scheduleNotification(Notification.createComplete());
	        this.unsubscribe();
	    };
	    return DelaySubscriber;
	}(Subscriber));
	var DelayMessage = /*@__PURE__*/ (function () {
	    function DelayMessage(time, notification) {
	        this.time = time;
	        this.notification = notification;
	    }
	    return DelayMessage;
	}());

	/** PURE_IMPORTS_START tslib,_Subscriber,_Observable,_OuterSubscriber,_util_subscribeToResult PURE_IMPORTS_END */
	function delayWhen(delayDurationSelector, subscriptionDelay) {
	    if (subscriptionDelay) {
	        return function (source) {
	            return new SubscriptionDelayObservable(source, subscriptionDelay)
	                .lift(new DelayWhenOperator(delayDurationSelector));
	        };
	    }
	    return function (source) { return source.lift(new DelayWhenOperator(delayDurationSelector)); };
	}
	var DelayWhenOperator = /*@__PURE__*/ (function () {
	    function DelayWhenOperator(delayDurationSelector) {
	        this.delayDurationSelector = delayDurationSelector;
	    }
	    DelayWhenOperator.prototype.call = function (subscriber, source) {
	        return source.subscribe(new DelayWhenSubscriber(subscriber, this.delayDurationSelector));
	    };
	    return DelayWhenOperator;
	}());
	var DelayWhenSubscriber = /*@__PURE__*/ (function (_super) {
	    __extends(DelayWhenSubscriber, _super);
	    function DelayWhenSubscriber(destination, delayDurationSelector) {
	        var _this = _super.call(this, destination) || this;
	        _this.delayDurationSelector = delayDurationSelector;
	        _this.completed = false;
	        _this.delayNotifierSubscriptions = [];
	        _this.index = 0;
	        return _this;
	    }
	    DelayWhenSubscriber.prototype.notifyNext = function (outerValue, _innerValue, _outerIndex, _innerIndex, innerSub) {
	        this.destination.next(outerValue);
	        this.removeSubscription(innerSub);
	        this.tryComplete();
	    };
	    DelayWhenSubscriber.prototype.notifyError = function (error, innerSub) {
	        this._error(error);
	    };
	    DelayWhenSubscriber.prototype.notifyComplete = function (innerSub) {
	        var value = this.removeSubscription(innerSub);
	        if (value) {
	            this.destination.next(value);
	        }
	        this.tryComplete();
	    };
	    DelayWhenSubscriber.prototype._next = function (value) {
	        var index = this.index++;
	        try {
	            var delayNotifier = this.delayDurationSelector(value, index);
	            if (delayNotifier) {
	                this.tryDelay(delayNotifier, value);
	            }
	        }
	        catch (err) {
	            this.destination.error(err);
	        }
	    };
	    DelayWhenSubscriber.prototype._complete = function () {
	        this.completed = true;
	        this.tryComplete();
	        this.unsubscribe();
	    };
	    DelayWhenSubscriber.prototype.removeSubscription = function (subscription) {
	        subscription.unsubscribe();
	        var subscriptionIdx = this.delayNotifierSubscriptions.indexOf(subscription);
	        if (subscriptionIdx !== -1) {
	            this.delayNotifierSubscriptions.splice(subscriptionIdx, 1);
	        }
	        return subscription.outerValue;
	    };
	    DelayWhenSubscriber.prototype.tryDelay = function (delayNotifier, value) {
	        var notifierSubscription = subscribeToResult(this, delayNotifier, value);
	        if (notifierSubscription && !notifierSubscription.closed) {
	            var destination = this.destination;
	            destination.add(notifierSubscription);
	            this.delayNotifierSubscriptions.push(notifierSubscription);
	        }
	    };
	    DelayWhenSubscriber.prototype.tryComplete = function () {
	        if (this.completed && this.delayNotifierSubscriptions.length === 0) {
	            this.destination.complete();
	        }
	    };
	    return DelayWhenSubscriber;
	}(OuterSubscriber));
	var SubscriptionDelayObservable = /*@__PURE__*/ (function (_super) {
	    __extends(SubscriptionDelayObservable, _super);
	    function SubscriptionDelayObservable(source, subscriptionDelay) {
	        var _this = _super.call(this) || this;
	        _this.source = source;
	        _this.subscriptionDelay = subscriptionDelay;
	        return _this;
	    }
	    SubscriptionDelayObservable.prototype._subscribe = function (subscriber) {
	        this.subscriptionDelay.subscribe(new SubscriptionDelaySubscriber(subscriber, this.source));
	    };
	    return SubscriptionDelayObservable;
	}(Observable));
	var SubscriptionDelaySubscriber = /*@__PURE__*/ (function (_super) {
	    __extends(SubscriptionDelaySubscriber, _super);
	    function SubscriptionDelaySubscriber(parent, source) {
	        var _this = _super.call(this) || this;
	        _this.parent = parent;
	        _this.source = source;
	        _this.sourceSubscribed = false;
	        return _this;
	    }
	    SubscriptionDelaySubscriber.prototype._next = function (unused) {
	        this.subscribeToSource();
	    };
	    SubscriptionDelaySubscriber.prototype._error = function (err) {
	        this.unsubscribe();
	        this.parent.error(err);
	    };
	    SubscriptionDelaySubscriber.prototype._complete = function () {
	        this.unsubscribe();
	        this.subscribeToSource();
	    };
	    SubscriptionDelaySubscriber.prototype.subscribeToSource = function () {
	        if (!this.sourceSubscribed) {
	            this.sourceSubscribed = true;
	            this.unsubscribe();
	            this.source.subscribe(this.parent);
	        }
	    };
	    return SubscriptionDelaySubscriber;
	}(Subscriber));

	/** PURE_IMPORTS_START tslib,_Subscriber PURE_IMPORTS_END */
	function dematerialize() {
	    return function dematerializeOperatorFunction(source) {
	        return source.lift(new DeMaterializeOperator());
	    };
	}
	var DeMaterializeOperator = /*@__PURE__*/ (function () {
	    function DeMaterializeOperator() {
	    }
	    DeMaterializeOperator.prototype.call = function (subscriber, source) {
	        return source.subscribe(new DeMaterializeSubscriber(subscriber));
	    };
	    return DeMaterializeOperator;
	}());
	var DeMaterializeSubscriber = /*@__PURE__*/ (function (_super) {
	    __extends(DeMaterializeSubscriber, _super);
	    function DeMaterializeSubscriber(destination) {
	        return _super.call(this, destination) || this;
	    }
	    DeMaterializeSubscriber.prototype._next = function (value) {
	        value.observe(this.destination);
	    };
	    return DeMaterializeSubscriber;
	}(Subscriber));

	/** PURE_IMPORTS_START tslib,_innerSubscribe PURE_IMPORTS_END */
	function distinct(keySelector, flushes) {
	    return function (source) { return source.lift(new DistinctOperator(keySelector, flushes)); };
	}
	var DistinctOperator = /*@__PURE__*/ (function () {
	    function DistinctOperator(keySelector, flushes) {
	        this.keySelector = keySelector;
	        this.flushes = flushes;
	    }
	    DistinctOperator.prototype.call = function (subscriber, source) {
	        return source.subscribe(new DistinctSubscriber(subscriber, this.keySelector, this.flushes));
	    };
	    return DistinctOperator;
	}());
	var DistinctSubscriber = /*@__PURE__*/ (function (_super) {
	    __extends(DistinctSubscriber, _super);
	    function DistinctSubscriber(destination, keySelector, flushes) {
	        var _this = _super.call(this, destination) || this;
	        _this.keySelector = keySelector;
	        _this.values = new Set();
	        if (flushes) {
	            _this.add(innerSubscribe(flushes, new SimpleInnerSubscriber(_this)));
	        }
	        return _this;
	    }
	    DistinctSubscriber.prototype.notifyNext = function () {
	        this.values.clear();
	    };
	    DistinctSubscriber.prototype.notifyError = function (error) {
	        this._error(error);
	    };
	    DistinctSubscriber.prototype._next = function (value) {
	        if (this.keySelector) {
	            this._useKeySelector(value);
	        }
	        else {
	            this._finalizeNext(value, value);
	        }
	    };
	    DistinctSubscriber.prototype._useKeySelector = function (value) {
	        var key;
	        var destination = this.destination;
	        try {
	            key = this.keySelector(value);
	        }
	        catch (err) {
	            destination.error(err);
	            return;
	        }
	        this._finalizeNext(key, value);
	    };
	    DistinctSubscriber.prototype._finalizeNext = function (key, value) {
	        var values = this.values;
	        if (!values.has(key)) {
	            values.add(key);
	            this.destination.next(value);
	        }
	    };
	    return DistinctSubscriber;
	}(SimpleOuterSubscriber));

	/** PURE_IMPORTS_START tslib,_Subscriber PURE_IMPORTS_END */
	function distinctUntilChanged(compare, keySelector) {
	    return function (source) { return source.lift(new DistinctUntilChangedOperator(compare, keySelector)); };
	}
	var DistinctUntilChangedOperator = /*@__PURE__*/ (function () {
	    function DistinctUntilChangedOperator(compare, keySelector) {
	        this.compare = compare;
	        this.keySelector = keySelector;
	    }
	    DistinctUntilChangedOperator.prototype.call = function (subscriber, source) {
	        return source.subscribe(new DistinctUntilChangedSubscriber(subscriber, this.compare, this.keySelector));
	    };
	    return DistinctUntilChangedOperator;
	}());
	var DistinctUntilChangedSubscriber = /*@__PURE__*/ (function (_super) {
	    __extends(DistinctUntilChangedSubscriber, _super);
	    function DistinctUntilChangedSubscriber(destination, compare, keySelector) {
	        var _this = _super.call(this, destination) || this;
	        _this.keySelector = keySelector;
	        _this.hasKey = false;
	        if (typeof compare === 'function') {
	            _this.compare = compare;
	        }
	        return _this;
	    }
	    DistinctUntilChangedSubscriber.prototype.compare = function (x, y) {
	        return x === y;
	    };
	    DistinctUntilChangedSubscriber.prototype._next = function (value) {
	        var key;
	        try {
	            var keySelector = this.keySelector;
	            key = keySelector ? keySelector(value) : value;
	        }
	        catch (err) {
	            return this.destination.error(err);
	        }
	        var result = false;
	        if (this.hasKey) {
	            try {
	                var compare = this.compare;
	                result = compare(this.key, key);
	            }
	            catch (err) {
	                return this.destination.error(err);
	            }
	        }
	        else {
	            this.hasKey = true;
	        }
	        if (!result) {
	            this.key = key;
	            this.destination.next(value);
	        }
	    };
	    return DistinctUntilChangedSubscriber;
	}(Subscriber));

	/** PURE_IMPORTS_START _distinctUntilChanged PURE_IMPORTS_END */
	function distinctUntilKeyChanged(key, compare) {
	    return distinctUntilChanged(function (x, y) { return compare ? compare(x[key], y[key]) : x[key] === y[key]; });
	}

	/** PURE_IMPORTS_START  PURE_IMPORTS_END */
	var ArgumentOutOfRangeErrorImpl = /*@__PURE__*/ (function () {
	    function ArgumentOutOfRangeErrorImpl() {
	        Error.call(this);
	        this.message = 'argument out of range';
	        this.name = 'ArgumentOutOfRangeError';
	        return this;
	    }
	    ArgumentOutOfRangeErrorImpl.prototype = /*@__PURE__*/ Object.create(Error.prototype);
	    return ArgumentOutOfRangeErrorImpl;
	})();
	var ArgumentOutOfRangeError = ArgumentOutOfRangeErrorImpl;

	/** PURE_IMPORTS_START tslib,_Subscriber PURE_IMPORTS_END */
	function filter(predicate, thisArg) {
	    return function filterOperatorFunction(source) {
	        return source.lift(new FilterOperator(predicate, thisArg));
	    };
	}
	var FilterOperator = /*@__PURE__*/ (function () {
	    function FilterOperator(predicate, thisArg) {
	        this.predicate = predicate;
	        this.thisArg = thisArg;
	    }
	    FilterOperator.prototype.call = function (subscriber, source) {
	        return source.subscribe(new FilterSubscriber(subscriber, this.predicate, this.thisArg));
	    };
	    return FilterOperator;
	}());
	var FilterSubscriber = /*@__PURE__*/ (function (_super) {
	    __extends(FilterSubscriber, _super);
	    function FilterSubscriber(destination, predicate, thisArg) {
	        var _this = _super.call(this, destination) || this;
	        _this.predicate = predicate;
	        _this.thisArg = thisArg;
	        _this.count = 0;
	        return _this;
	    }
	    FilterSubscriber.prototype._next = function (value) {
	        var result;
	        try {
	            result = this.predicate.call(this.thisArg, value, this.count++);
	        }
	        catch (err) {
	            this.destination.error(err);
	            return;
	        }
	        if (result) {
	            this.destination.next(value);
	        }
	    };
	    return FilterSubscriber;
	}(Subscriber));

	/** PURE_IMPORTS_START  PURE_IMPORTS_END */
	var EmptyErrorImpl = /*@__PURE__*/ (function () {
	    function EmptyErrorImpl() {
	        Error.call(this);
	        this.message = 'no elements in sequence';
	        this.name = 'EmptyError';
	        return this;
	    }
	    EmptyErrorImpl.prototype = /*@__PURE__*/ Object.create(Error.prototype);
	    return EmptyErrorImpl;
	})();
	var EmptyError = EmptyErrorImpl;

	/** PURE_IMPORTS_START tslib,_util_EmptyError,_Subscriber PURE_IMPORTS_END */
	function throwIfEmpty(errorFactory) {
	    if (errorFactory === void 0) {
	        errorFactory = defaultErrorFactory;
	    }
	    return function (source) {
	        return source.lift(new ThrowIfEmptyOperator(errorFactory));
	    };
	}
	var ThrowIfEmptyOperator = /*@__PURE__*/ (function () {
	    function ThrowIfEmptyOperator(errorFactory) {
	        this.errorFactory = errorFactory;
	    }
	    ThrowIfEmptyOperator.prototype.call = function (subscriber, source) {
	        return source.subscribe(new ThrowIfEmptySubscriber(subscriber, this.errorFactory));
	    };
	    return ThrowIfEmptyOperator;
	}());
	var ThrowIfEmptySubscriber = /*@__PURE__*/ (function (_super) {
	    __extends(ThrowIfEmptySubscriber, _super);
	    function ThrowIfEmptySubscriber(destination, errorFactory) {
	        var _this = _super.call(this, destination) || this;
	        _this.errorFactory = errorFactory;
	        _this.hasValue = false;
	        return _this;
	    }
	    ThrowIfEmptySubscriber.prototype._next = function (value) {
	        this.hasValue = true;
	        this.destination.next(value);
	    };
	    ThrowIfEmptySubscriber.prototype._complete = function () {
	        if (!this.hasValue) {
	            var err = void 0;
	            try {
	                err = this.errorFactory();
	            }
	            catch (e) {
	                err = e;
	            }
	            this.destination.error(err);
	        }
	        else {
	            return this.destination.complete();
	        }
	    };
	    return ThrowIfEmptySubscriber;
	}(Subscriber));
	function defaultErrorFactory() {
	    return new EmptyError();
	}

	/** PURE_IMPORTS_START tslib,_Subscriber,_util_ArgumentOutOfRangeError,_observable_empty PURE_IMPORTS_END */
	function take(count) {
	    return function (source) {
	        if (count === 0) {
	            return empty();
	        }
	        else {
	            return source.lift(new TakeOperator(count));
	        }
	    };
	}
	var TakeOperator = /*@__PURE__*/ (function () {
	    function TakeOperator(total) {
	        this.total = total;
	        if (this.total < 0) {
	            throw new ArgumentOutOfRangeError;
	        }
	    }
	    TakeOperator.prototype.call = function (subscriber, source) {
	        return source.subscribe(new TakeSubscriber(subscriber, this.total));
	    };
	    return TakeOperator;
	}());
	var TakeSubscriber = /*@__PURE__*/ (function (_super) {
	    __extends(TakeSubscriber, _super);
	    function TakeSubscriber(destination, total) {
	        var _this = _super.call(this, destination) || this;
	        _this.total = total;
	        _this.count = 0;
	        return _this;
	    }
	    TakeSubscriber.prototype._next = function (value) {
	        var total = this.total;
	        var count = ++this.count;
	        if (count <= total) {
	            this.destination.next(value);
	            if (count === total) {
	                this.destination.complete();
	                this.unsubscribe();
	            }
	        }
	    };
	    return TakeSubscriber;
	}(Subscriber));

	/** PURE_IMPORTS_START _util_ArgumentOutOfRangeError,_filter,_throwIfEmpty,_defaultIfEmpty,_take PURE_IMPORTS_END */
	function elementAt(index, defaultValue) {
	    if (index < 0) {
	        throw new ArgumentOutOfRangeError();
	    }
	    var hasDefaultValue = arguments.length >= 2;
	    return function (source) {
	        return source.pipe(filter(function (v, i) { return i === index; }), take(1), hasDefaultValue
	            ? defaultIfEmpty(defaultValue)
	            : throwIfEmpty(function () { return new ArgumentOutOfRangeError(); }));
	    };
	}

	/** PURE_IMPORTS_START _observable_concat,_observable_of PURE_IMPORTS_END */
	function endWith() {
	    var array = [];
	    for (var _i = 0; _i < arguments.length; _i++) {
	        array[_i] = arguments[_i];
	    }
	    return function (source) { return concat$1(source, of.apply(void 0, array)); };
	}

	/** PURE_IMPORTS_START tslib,_Subscriber PURE_IMPORTS_END */
	function every(predicate, thisArg) {
	    return function (source) { return source.lift(new EveryOperator(predicate, thisArg, source)); };
	}
	var EveryOperator = /*@__PURE__*/ (function () {
	    function EveryOperator(predicate, thisArg, source) {
	        this.predicate = predicate;
	        this.thisArg = thisArg;
	        this.source = source;
	    }
	    EveryOperator.prototype.call = function (observer, source) {
	        return source.subscribe(new EverySubscriber(observer, this.predicate, this.thisArg, this.source));
	    };
	    return EveryOperator;
	}());
	var EverySubscriber = /*@__PURE__*/ (function (_super) {
	    __extends(EverySubscriber, _super);
	    function EverySubscriber(destination, predicate, thisArg, source) {
	        var _this = _super.call(this, destination) || this;
	        _this.predicate = predicate;
	        _this.thisArg = thisArg;
	        _this.source = source;
	        _this.index = 0;
	        _this.thisArg = thisArg || _this;
	        return _this;
	    }
	    EverySubscriber.prototype.notifyComplete = function (everyValueMatch) {
	        this.destination.next(everyValueMatch);
	        this.destination.complete();
	    };
	    EverySubscriber.prototype._next = function (value) {
	        var result = false;
	        try {
	            result = this.predicate.call(this.thisArg, value, this.index++, this.source);
	        }
	        catch (err) {
	            this.destination.error(err);
	            return;
	        }
	        if (!result) {
	            this.notifyComplete(false);
	        }
	    };
	    EverySubscriber.prototype._complete = function () {
	        this.notifyComplete(true);
	    };
	    return EverySubscriber;
	}(Subscriber));

	/** PURE_IMPORTS_START tslib,_innerSubscribe PURE_IMPORTS_END */
	function exhaust() {
	    return function (source) { return source.lift(new SwitchFirstOperator()); };
	}
	var SwitchFirstOperator = /*@__PURE__*/ (function () {
	    function SwitchFirstOperator() {
	    }
	    SwitchFirstOperator.prototype.call = function (subscriber, source) {
	        return source.subscribe(new SwitchFirstSubscriber(subscriber));
	    };
	    return SwitchFirstOperator;
	}());
	var SwitchFirstSubscriber = /*@__PURE__*/ (function (_super) {
	    __extends(SwitchFirstSubscriber, _super);
	    function SwitchFirstSubscriber(destination) {
	        var _this = _super.call(this, destination) || this;
	        _this.hasCompleted = false;
	        _this.hasSubscription = false;
	        return _this;
	    }
	    SwitchFirstSubscriber.prototype._next = function (value) {
	        if (!this.hasSubscription) {
	            this.hasSubscription = true;
	            this.add(innerSubscribe(value, new SimpleInnerSubscriber(this)));
	        }
	    };
	    SwitchFirstSubscriber.prototype._complete = function () {
	        this.hasCompleted = true;
	        if (!this.hasSubscription) {
	            this.destination.complete();
	        }
	    };
	    SwitchFirstSubscriber.prototype.notifyComplete = function () {
	        this.hasSubscription = false;
	        if (this.hasCompleted) {
	            this.destination.complete();
	        }
	    };
	    return SwitchFirstSubscriber;
	}(SimpleOuterSubscriber));

	/** PURE_IMPORTS_START tslib,_map,_observable_from,_innerSubscribe PURE_IMPORTS_END */
	function exhaustMap(project, resultSelector) {
	    if (resultSelector) {
	        return function (source) { return source.pipe(exhaustMap(function (a, i) { return from(project(a, i)).pipe(map(function (b, ii) { return resultSelector(a, b, i, ii); })); })); };
	    }
	    return function (source) {
	        return source.lift(new ExhaustMapOperator(project));
	    };
	}
	var ExhaustMapOperator = /*@__PURE__*/ (function () {
	    function ExhaustMapOperator(project) {
	        this.project = project;
	    }
	    ExhaustMapOperator.prototype.call = function (subscriber, source) {
	        return source.subscribe(new ExhaustMapSubscriber(subscriber, this.project));
	    };
	    return ExhaustMapOperator;
	}());
	var ExhaustMapSubscriber = /*@__PURE__*/ (function (_super) {
	    __extends(ExhaustMapSubscriber, _super);
	    function ExhaustMapSubscriber(destination, project) {
	        var _this = _super.call(this, destination) || this;
	        _this.project = project;
	        _this.hasSubscription = false;
	        _this.hasCompleted = false;
	        _this.index = 0;
	        return _this;
	    }
	    ExhaustMapSubscriber.prototype._next = function (value) {
	        if (!this.hasSubscription) {
	            this.tryNext(value);
	        }
	    };
	    ExhaustMapSubscriber.prototype.tryNext = function (value) {
	        var result;
	        var index = this.index++;
	        try {
	            result = this.project(value, index);
	        }
	        catch (err) {
	            this.destination.error(err);
	            return;
	        }
	        this.hasSubscription = true;
	        this._innerSub(result);
	    };
	    ExhaustMapSubscriber.prototype._innerSub = function (result) {
	        var innerSubscriber = new SimpleInnerSubscriber(this);
	        var destination = this.destination;
	        destination.add(innerSubscriber);
	        var innerSubscription = innerSubscribe(result, innerSubscriber);
	        if (innerSubscription !== innerSubscriber) {
	            destination.add(innerSubscription);
	        }
	    };
	    ExhaustMapSubscriber.prototype._complete = function () {
	        this.hasCompleted = true;
	        if (!this.hasSubscription) {
	            this.destination.complete();
	        }
	        this.unsubscribe();
	    };
	    ExhaustMapSubscriber.prototype.notifyNext = function (innerValue) {
	        this.destination.next(innerValue);
	    };
	    ExhaustMapSubscriber.prototype.notifyError = function (err) {
	        this.destination.error(err);
	    };
	    ExhaustMapSubscriber.prototype.notifyComplete = function () {
	        this.hasSubscription = false;
	        if (this.hasCompleted) {
	            this.destination.complete();
	        }
	    };
	    return ExhaustMapSubscriber;
	}(SimpleOuterSubscriber));

	/** PURE_IMPORTS_START tslib,_innerSubscribe PURE_IMPORTS_END */
	function expand(project, concurrent, scheduler) {
	    if (concurrent === void 0) {
	        concurrent = Number.POSITIVE_INFINITY;
	    }
	    concurrent = (concurrent || 0) < 1 ? Number.POSITIVE_INFINITY : concurrent;
	    return function (source) { return source.lift(new ExpandOperator(project, concurrent, scheduler)); };
	}
	var ExpandOperator = /*@__PURE__*/ (function () {
	    function ExpandOperator(project, concurrent, scheduler) {
	        this.project = project;
	        this.concurrent = concurrent;
	        this.scheduler = scheduler;
	    }
	    ExpandOperator.prototype.call = function (subscriber, source) {
	        return source.subscribe(new ExpandSubscriber(subscriber, this.project, this.concurrent, this.scheduler));
	    };
	    return ExpandOperator;
	}());
	var ExpandSubscriber = /*@__PURE__*/ (function (_super) {
	    __extends(ExpandSubscriber, _super);
	    function ExpandSubscriber(destination, project, concurrent, scheduler) {
	        var _this = _super.call(this, destination) || this;
	        _this.project = project;
	        _this.concurrent = concurrent;
	        _this.scheduler = scheduler;
	        _this.index = 0;
	        _this.active = 0;
	        _this.hasCompleted = false;
	        if (concurrent < Number.POSITIVE_INFINITY) {
	            _this.buffer = [];
	        }
	        return _this;
	    }
	    ExpandSubscriber.dispatch = function (arg) {
	        var subscriber = arg.subscriber, result = arg.result, value = arg.value, index = arg.index;
	        subscriber.subscribeToProjection(result, value, index);
	    };
	    ExpandSubscriber.prototype._next = function (value) {
	        var destination = this.destination;
	        if (destination.closed) {
	            this._complete();
	            return;
	        }
	        var index = this.index++;
	        if (this.active < this.concurrent) {
	            destination.next(value);
	            try {
	                var project = this.project;
	                var result = project(value, index);
	                if (!this.scheduler) {
	                    this.subscribeToProjection(result, value, index);
	                }
	                else {
	                    var state = { subscriber: this, result: result, value: value, index: index };
	                    var destination_1 = this.destination;
	                    destination_1.add(this.scheduler.schedule(ExpandSubscriber.dispatch, 0, state));
	                }
	            }
	            catch (e) {
	                destination.error(e);
	            }
	        }
	        else {
	            this.buffer.push(value);
	        }
	    };
	    ExpandSubscriber.prototype.subscribeToProjection = function (result, value, index) {
	        this.active++;
	        var destination = this.destination;
	        destination.add(innerSubscribe(result, new SimpleInnerSubscriber(this)));
	    };
	    ExpandSubscriber.prototype._complete = function () {
	        this.hasCompleted = true;
	        if (this.hasCompleted && this.active === 0) {
	            this.destination.complete();
	        }
	        this.unsubscribe();
	    };
	    ExpandSubscriber.prototype.notifyNext = function (innerValue) {
	        this._next(innerValue);
	    };
	    ExpandSubscriber.prototype.notifyComplete = function () {
	        var buffer = this.buffer;
	        this.active--;
	        if (buffer && buffer.length > 0) {
	            this._next(buffer.shift());
	        }
	        if (this.hasCompleted && this.active === 0) {
	            this.destination.complete();
	        }
	    };
	    return ExpandSubscriber;
	}(SimpleOuterSubscriber));

	/** PURE_IMPORTS_START tslib,_Subscriber,_Subscription PURE_IMPORTS_END */
	function finalize(callback) {
	    return function (source) { return source.lift(new FinallyOperator(callback)); };
	}
	var FinallyOperator = /*@__PURE__*/ (function () {
	    function FinallyOperator(callback) {
	        this.callback = callback;
	    }
	    FinallyOperator.prototype.call = function (subscriber, source) {
	        return source.subscribe(new FinallySubscriber(subscriber, this.callback));
	    };
	    return FinallyOperator;
	}());
	var FinallySubscriber = /*@__PURE__*/ (function (_super) {
	    __extends(FinallySubscriber, _super);
	    function FinallySubscriber(destination, callback) {
	        var _this = _super.call(this, destination) || this;
	        _this.add(new Subscription(callback));
	        return _this;
	    }
	    return FinallySubscriber;
	}(Subscriber));

	/** PURE_IMPORTS_START tslib,_Subscriber PURE_IMPORTS_END */
	function find(predicate, thisArg) {
	    if (typeof predicate !== 'function') {
	        throw new TypeError('predicate is not a function');
	    }
	    return function (source) { return source.lift(new FindValueOperator(predicate, source, false, thisArg)); };
	}
	var FindValueOperator = /*@__PURE__*/ (function () {
	    function FindValueOperator(predicate, source, yieldIndex, thisArg) {
	        this.predicate = predicate;
	        this.source = source;
	        this.yieldIndex = yieldIndex;
	        this.thisArg = thisArg;
	    }
	    FindValueOperator.prototype.call = function (observer, source) {
	        return source.subscribe(new FindValueSubscriber(observer, this.predicate, this.source, this.yieldIndex, this.thisArg));
	    };
	    return FindValueOperator;
	}());
	var FindValueSubscriber = /*@__PURE__*/ (function (_super) {
	    __extends(FindValueSubscriber, _super);
	    function FindValueSubscriber(destination, predicate, source, yieldIndex, thisArg) {
	        var _this = _super.call(this, destination) || this;
	        _this.predicate = predicate;
	        _this.source = source;
	        _this.yieldIndex = yieldIndex;
	        _this.thisArg = thisArg;
	        _this.index = 0;
	        return _this;
	    }
	    FindValueSubscriber.prototype.notifyComplete = function (value) {
	        var destination = this.destination;
	        destination.next(value);
	        destination.complete();
	        this.unsubscribe();
	    };
	    FindValueSubscriber.prototype._next = function (value) {
	        var _a = this, predicate = _a.predicate, thisArg = _a.thisArg;
	        var index = this.index++;
	        try {
	            var result = predicate.call(thisArg || this, value, index, this.source);
	            if (result) {
	                this.notifyComplete(this.yieldIndex ? index : value);
	            }
	        }
	        catch (err) {
	            this.destination.error(err);
	        }
	    };
	    FindValueSubscriber.prototype._complete = function () {
	        this.notifyComplete(this.yieldIndex ? -1 : undefined);
	    };
	    return FindValueSubscriber;
	}(Subscriber));

	/** PURE_IMPORTS_START _operators_find PURE_IMPORTS_END */
	function findIndex(predicate, thisArg) {
	    return function (source) { return source.lift(new FindValueOperator(predicate, source, true, thisArg)); };
	}

	/** PURE_IMPORTS_START _util_EmptyError,_filter,_take,_defaultIfEmpty,_throwIfEmpty,_util_identity PURE_IMPORTS_END */
	function first(predicate, defaultValue) {
	    var hasDefaultValue = arguments.length >= 2;
	    return function (source) { return source.pipe(predicate ? filter(function (v, i) { return predicate(v, i, source); }) : identity, take(1), hasDefaultValue ? defaultIfEmpty(defaultValue) : throwIfEmpty(function () { return new EmptyError(); })); };
	}

	/** PURE_IMPORTS_START tslib,_Subscriber,_Subscription,_Observable,_Subject PURE_IMPORTS_END */
	function groupBy(keySelector, elementSelector, durationSelector, subjectSelector) {
	    return function (source) {
	        return source.lift(new GroupByOperator(keySelector, elementSelector, durationSelector, subjectSelector));
	    };
	}
	var GroupByOperator = /*@__PURE__*/ (function () {
	    function GroupByOperator(keySelector, elementSelector, durationSelector, subjectSelector) {
	        this.keySelector = keySelector;
	        this.elementSelector = elementSelector;
	        this.durationSelector = durationSelector;
	        this.subjectSelector = subjectSelector;
	    }
	    GroupByOperator.prototype.call = function (subscriber, source) {
	        return source.subscribe(new GroupBySubscriber(subscriber, this.keySelector, this.elementSelector, this.durationSelector, this.subjectSelector));
	    };
	    return GroupByOperator;
	}());
	var GroupBySubscriber = /*@__PURE__*/ (function (_super) {
	    __extends(GroupBySubscriber, _super);
	    function GroupBySubscriber(destination, keySelector, elementSelector, durationSelector, subjectSelector) {
	        var _this = _super.call(this, destination) || this;
	        _this.keySelector = keySelector;
	        _this.elementSelector = elementSelector;
	        _this.durationSelector = durationSelector;
	        _this.subjectSelector = subjectSelector;
	        _this.groups = null;
	        _this.attemptedToUnsubscribe = false;
	        _this.count = 0;
	        return _this;
	    }
	    GroupBySubscriber.prototype._next = function (value) {
	        var key;
	        try {
	            key = this.keySelector(value);
	        }
	        catch (err) {
	            this.error(err);
	            return;
	        }
	        this._group(value, key);
	    };
	    GroupBySubscriber.prototype._group = function (value, key) {
	        var groups = this.groups;
	        if (!groups) {
	            groups = this.groups = new Map();
	        }
	        var group = groups.get(key);
	        var element;
	        if (this.elementSelector) {
	            try {
	                element = this.elementSelector(value);
	            }
	            catch (err) {
	                this.error(err);
	            }
	        }
	        else {
	            element = value;
	        }
	        if (!group) {
	            group = (this.subjectSelector ? this.subjectSelector() : new Subject());
	            groups.set(key, group);
	            var groupedObservable = new GroupedObservable(key, group, this);
	            this.destination.next(groupedObservable);
	            if (this.durationSelector) {
	                var duration = void 0;
	                try {
	                    duration = this.durationSelector(new GroupedObservable(key, group));
	                }
	                catch (err) {
	                    this.error(err);
	                    return;
	                }
	                this.add(duration.subscribe(new GroupDurationSubscriber(key, group, this)));
	            }
	        }
	        if (!group.closed) {
	            group.next(element);
	        }
	    };
	    GroupBySubscriber.prototype._error = function (err) {
	        var groups = this.groups;
	        if (groups) {
	            groups.forEach(function (group, key) {
	                group.error(err);
	            });
	            groups.clear();
	        }
	        this.destination.error(err);
	    };
	    GroupBySubscriber.prototype._complete = function () {
	        var groups = this.groups;
	        if (groups) {
	            groups.forEach(function (group, key) {
	                group.complete();
	            });
	            groups.clear();
	        }
	        this.destination.complete();
	    };
	    GroupBySubscriber.prototype.removeGroup = function (key) {
	        this.groups.delete(key);
	    };
	    GroupBySubscriber.prototype.unsubscribe = function () {
	        if (!this.closed) {
	            this.attemptedToUnsubscribe = true;
	            if (this.count === 0) {
	                _super.prototype.unsubscribe.call(this);
	            }
	        }
	    };
	    return GroupBySubscriber;
	}(Subscriber));
	var GroupDurationSubscriber = /*@__PURE__*/ (function (_super) {
	    __extends(GroupDurationSubscriber, _super);
	    function GroupDurationSubscriber(key, group, parent) {
	        var _this = _super.call(this, group) || this;
	        _this.key = key;
	        _this.group = group;
	        _this.parent = parent;
	        return _this;
	    }
	    GroupDurationSubscriber.prototype._next = function (value) {
	        this.complete();
	    };
	    GroupDurationSubscriber.prototype._unsubscribe = function () {
	        var _a = this, parent = _a.parent, key = _a.key;
	        this.key = this.parent = null;
	        if (parent) {
	            parent.removeGroup(key);
	        }
	    };
	    return GroupDurationSubscriber;
	}(Subscriber));
	var GroupedObservable = /*@__PURE__*/ (function (_super) {
	    __extends(GroupedObservable, _super);
	    function GroupedObservable(key, groupSubject, refCountSubscription) {
	        var _this = _super.call(this) || this;
	        _this.key = key;
	        _this.groupSubject = groupSubject;
	        _this.refCountSubscription = refCountSubscription;
	        return _this;
	    }
	    GroupedObservable.prototype._subscribe = function (subscriber) {
	        var subscription = new Subscription();
	        var _a = this, refCountSubscription = _a.refCountSubscription, groupSubject = _a.groupSubject;
	        if (refCountSubscription && !refCountSubscription.closed) {
	            subscription.add(new InnerRefCountSubscription(refCountSubscription));
	        }
	        subscription.add(groupSubject.subscribe(subscriber));
	        return subscription;
	    };
	    return GroupedObservable;
	}(Observable));
	var InnerRefCountSubscription = /*@__PURE__*/ (function (_super) {
	    __extends(InnerRefCountSubscription, _super);
	    function InnerRefCountSubscription(parent) {
	        var _this = _super.call(this) || this;
	        _this.parent = parent;
	        parent.count++;
	        return _this;
	    }
	    InnerRefCountSubscription.prototype.unsubscribe = function () {
	        var parent = this.parent;
	        if (!parent.closed && !this.closed) {
	            _super.prototype.unsubscribe.call(this);
	            parent.count -= 1;
	            if (parent.count === 0 && parent.attemptedToUnsubscribe) {
	                parent.unsubscribe();
	            }
	        }
	    };
	    return InnerRefCountSubscription;
	}(Subscription));

	/** PURE_IMPORTS_START tslib,_Subscriber PURE_IMPORTS_END */
	function ignoreElements() {
	    return function ignoreElementsOperatorFunction(source) {
	        return source.lift(new IgnoreElementsOperator());
	    };
	}
	var IgnoreElementsOperator = /*@__PURE__*/ (function () {
	    function IgnoreElementsOperator() {
	    }
	    IgnoreElementsOperator.prototype.call = function (subscriber, source) {
	        return source.subscribe(new IgnoreElementsSubscriber(subscriber));
	    };
	    return IgnoreElementsOperator;
	}());
	var IgnoreElementsSubscriber = /*@__PURE__*/ (function (_super) {
	    __extends(IgnoreElementsSubscriber, _super);
	    function IgnoreElementsSubscriber() {
	        return _super !== null && _super.apply(this, arguments) || this;
	    }
	    IgnoreElementsSubscriber.prototype._next = function (unused) {
	    };
	    return IgnoreElementsSubscriber;
	}(Subscriber));

	/** PURE_IMPORTS_START tslib,_Subscriber PURE_IMPORTS_END */
	function isEmpty() {
	    return function (source) { return source.lift(new IsEmptyOperator()); };
	}
	var IsEmptyOperator = /*@__PURE__*/ (function () {
	    function IsEmptyOperator() {
	    }
	    IsEmptyOperator.prototype.call = function (observer, source) {
	        return source.subscribe(new IsEmptySubscriber(observer));
	    };
	    return IsEmptyOperator;
	}());
	var IsEmptySubscriber = /*@__PURE__*/ (function (_super) {
	    __extends(IsEmptySubscriber, _super);
	    function IsEmptySubscriber(destination) {
	        return _super.call(this, destination) || this;
	    }
	    IsEmptySubscriber.prototype.notifyComplete = function (isEmpty) {
	        var destination = this.destination;
	        destination.next(isEmpty);
	        destination.complete();
	    };
	    IsEmptySubscriber.prototype._next = function (value) {
	        this.notifyComplete(false);
	    };
	    IsEmptySubscriber.prototype._complete = function () {
	        this.notifyComplete(true);
	    };
	    return IsEmptySubscriber;
	}(Subscriber));

	/** PURE_IMPORTS_START tslib,_Subscriber,_util_ArgumentOutOfRangeError,_observable_empty PURE_IMPORTS_END */
	function takeLast(count) {
	    return function takeLastOperatorFunction(source) {
	        if (count === 0) {
	            return empty();
	        }
	        else {
	            return source.lift(new TakeLastOperator(count));
	        }
	    };
	}
	var TakeLastOperator = /*@__PURE__*/ (function () {
	    function TakeLastOperator(total) {
	        this.total = total;
	        if (this.total < 0) {
	            throw new ArgumentOutOfRangeError;
	        }
	    }
	    TakeLastOperator.prototype.call = function (subscriber, source) {
	        return source.subscribe(new TakeLastSubscriber(subscriber, this.total));
	    };
	    return TakeLastOperator;
	}());
	var TakeLastSubscriber = /*@__PURE__*/ (function (_super) {
	    __extends(TakeLastSubscriber, _super);
	    function TakeLastSubscriber(destination, total) {
	        var _this = _super.call(this, destination) || this;
	        _this.total = total;
	        _this.ring = new Array();
	        _this.count = 0;
	        return _this;
	    }
	    TakeLastSubscriber.prototype._next = function (value) {
	        var ring = this.ring;
	        var total = this.total;
	        var count = this.count++;
	        if (ring.length < total) {
	            ring.push(value);
	        }
	        else {
	            var index = count % total;
	            ring[index] = value;
	        }
	    };
	    TakeLastSubscriber.prototype._complete = function () {
	        var destination = this.destination;
	        var count = this.count;
	        if (count > 0) {
	            var total = this.count >= this.total ? this.total : this.count;
	            var ring = this.ring;
	            for (var i = 0; i < total; i++) {
	                var idx = (count++) % total;
	                destination.next(ring[idx]);
	            }
	        }
	        destination.complete();
	    };
	    return TakeLastSubscriber;
	}(Subscriber));

	/** PURE_IMPORTS_START _util_EmptyError,_filter,_takeLast,_throwIfEmpty,_defaultIfEmpty,_util_identity PURE_IMPORTS_END */
	function last(predicate, defaultValue) {
	    var hasDefaultValue = arguments.length >= 2;
	    return function (source) { return source.pipe(predicate ? filter(function (v, i) { return predicate(v, i, source); }) : identity, takeLast(1), hasDefaultValue ? defaultIfEmpty(defaultValue) : throwIfEmpty(function () { return new EmptyError(); })); };
	}

	/** PURE_IMPORTS_START tslib,_Subscriber PURE_IMPORTS_END */
	function mapTo(value) {
	    return function (source) { return source.lift(new MapToOperator(value)); };
	}
	var MapToOperator = /*@__PURE__*/ (function () {
	    function MapToOperator(value) {
	        this.value = value;
	    }
	    MapToOperator.prototype.call = function (subscriber, source) {
	        return source.subscribe(new MapToSubscriber(subscriber, this.value));
	    };
	    return MapToOperator;
	}());
	var MapToSubscriber = /*@__PURE__*/ (function (_super) {
	    __extends(MapToSubscriber, _super);
	    function MapToSubscriber(destination, value) {
	        var _this = _super.call(this, destination) || this;
	        _this.value = value;
	        return _this;
	    }
	    MapToSubscriber.prototype._next = function (x) {
	        this.destination.next(this.value);
	    };
	    return MapToSubscriber;
	}(Subscriber));

	/** PURE_IMPORTS_START tslib,_Subscriber,_Notification PURE_IMPORTS_END */
	function materialize() {
	    return function materializeOperatorFunction(source) {
	        return source.lift(new MaterializeOperator());
	    };
	}
	var MaterializeOperator = /*@__PURE__*/ (function () {
	    function MaterializeOperator() {
	    }
	    MaterializeOperator.prototype.call = function (subscriber, source) {
	        return source.subscribe(new MaterializeSubscriber(subscriber));
	    };
	    return MaterializeOperator;
	}());
	var MaterializeSubscriber = /*@__PURE__*/ (function (_super) {
	    __extends(MaterializeSubscriber, _super);
	    function MaterializeSubscriber(destination) {
	        return _super.call(this, destination) || this;
	    }
	    MaterializeSubscriber.prototype._next = function (value) {
	        this.destination.next(Notification.createNext(value));
	    };
	    MaterializeSubscriber.prototype._error = function (err) {
	        var destination = this.destination;
	        destination.next(Notification.createError(err));
	        destination.complete();
	    };
	    MaterializeSubscriber.prototype._complete = function () {
	        var destination = this.destination;
	        destination.next(Notification.createComplete());
	        destination.complete();
	    };
	    return MaterializeSubscriber;
	}(Subscriber));

	/** PURE_IMPORTS_START tslib,_Subscriber PURE_IMPORTS_END */
	function scan(accumulator, seed) {
	    var hasSeed = false;
	    if (arguments.length >= 2) {
	        hasSeed = true;
	    }
	    return function scanOperatorFunction(source) {
	        return source.lift(new ScanOperator(accumulator, seed, hasSeed));
	    };
	}
	var ScanOperator = /*@__PURE__*/ (function () {
	    function ScanOperator(accumulator, seed, hasSeed) {
	        if (hasSeed === void 0) {
	            hasSeed = false;
	        }
	        this.accumulator = accumulator;
	        this.seed = seed;
	        this.hasSeed = hasSeed;
	    }
	    ScanOperator.prototype.call = function (subscriber, source) {
	        return source.subscribe(new ScanSubscriber(subscriber, this.accumulator, this.seed, this.hasSeed));
	    };
	    return ScanOperator;
	}());
	var ScanSubscriber = /*@__PURE__*/ (function (_super) {
	    __extends(ScanSubscriber, _super);
	    function ScanSubscriber(destination, accumulator, _seed, hasSeed) {
	        var _this = _super.call(this, destination) || this;
	        _this.accumulator = accumulator;
	        _this._seed = _seed;
	        _this.hasSeed = hasSeed;
	        _this.index = 0;
	        return _this;
	    }
	    Object.defineProperty(ScanSubscriber.prototype, "seed", {
	        get: function () {
	            return this._seed;
	        },
	        set: function (value) {
	            this.hasSeed = true;
	            this._seed = value;
	        },
	        enumerable: true,
	        configurable: true
	    });
	    ScanSubscriber.prototype._next = function (value) {
	        if (!this.hasSeed) {
	            this.seed = value;
	            this.destination.next(value);
	        }
	        else {
	            return this._tryNext(value);
	        }
	    };
	    ScanSubscriber.prototype._tryNext = function (value) {
	        var index = this.index++;
	        var result;
	        try {
	            result = this.accumulator(this.seed, value, index);
	        }
	        catch (err) {
	            this.destination.error(err);
	        }
	        this.seed = result;
	        this.destination.next(result);
	    };
	    return ScanSubscriber;
	}(Subscriber));

	/** PURE_IMPORTS_START _scan,_takeLast,_defaultIfEmpty,_util_pipe PURE_IMPORTS_END */
	function reduce(accumulator, seed) {
	    if (arguments.length >= 2) {
	        return function reduceOperatorFunctionWithSeed(source) {
	            return pipe(scan(accumulator, seed), takeLast(1), defaultIfEmpty(seed))(source);
	        };
	    }
	    return function reduceOperatorFunction(source) {
	        return pipe(scan(function (acc, value, index) { return accumulator(acc, value, index + 1); }), takeLast(1))(source);
	    };
	}

	/** PURE_IMPORTS_START _reduce PURE_IMPORTS_END */
	function max(comparer) {
	    var max = (typeof comparer === 'function')
	        ? function (x, y) { return comparer(x, y) > 0 ? x : y; }
	        : function (x, y) { return x > y ? x : y; };
	    return reduce(max);
	}

	/** PURE_IMPORTS_START _Observable,_util_isScheduler,_operators_mergeAll,_fromArray PURE_IMPORTS_END */
	function merge$1() {
	    var observables = [];
	    for (var _i = 0; _i < arguments.length; _i++) {
	        observables[_i] = arguments[_i];
	    }
	    var concurrent = Number.POSITIVE_INFINITY;
	    var scheduler = null;
	    var last = observables[observables.length - 1];
	    if (isScheduler(last)) {
	        scheduler = observables.pop();
	        if (observables.length > 1 && typeof observables[observables.length - 1] === 'number') {
	            concurrent = observables.pop();
	        }
	    }
	    else if (typeof last === 'number') {
	        concurrent = observables.pop();
	    }
	    if (scheduler === null && observables.length === 1 && observables[0] instanceof Observable) {
	        return observables[0];
	    }
	    return mergeAll(concurrent)(fromArray(observables, scheduler));
	}

	/** PURE_IMPORTS_START _observable_merge PURE_IMPORTS_END */
	function merge() {
	    var observables = [];
	    for (var _i = 0; _i < arguments.length; _i++) {
	        observables[_i] = arguments[_i];
	    }
	    return function (source) { return source.lift.call(merge$1.apply(void 0, [source].concat(observables))); };
	}

	/** PURE_IMPORTS_START _mergeMap PURE_IMPORTS_END */
	function mergeMapTo(innerObservable, resultSelector, concurrent) {
	    if (concurrent === void 0) {
	        concurrent = Number.POSITIVE_INFINITY;
	    }
	    if (typeof resultSelector === 'function') {
	        return mergeMap(function () { return innerObservable; }, resultSelector, concurrent);
	    }
	    if (typeof resultSelector === 'number') {
	        concurrent = resultSelector;
	    }
	    return mergeMap(function () { return innerObservable; }, concurrent);
	}

	/** PURE_IMPORTS_START tslib,_innerSubscribe PURE_IMPORTS_END */
	function mergeScan(accumulator, seed, concurrent) {
	    if (concurrent === void 0) {
	        concurrent = Number.POSITIVE_INFINITY;
	    }
	    return function (source) { return source.lift(new MergeScanOperator(accumulator, seed, concurrent)); };
	}
	var MergeScanOperator = /*@__PURE__*/ (function () {
	    function MergeScanOperator(accumulator, seed, concurrent) {
	        this.accumulator = accumulator;
	        this.seed = seed;
	        this.concurrent = concurrent;
	    }
	    MergeScanOperator.prototype.call = function (subscriber, source) {
	        return source.subscribe(new MergeScanSubscriber(subscriber, this.accumulator, this.seed, this.concurrent));
	    };
	    return MergeScanOperator;
	}());
	var MergeScanSubscriber = /*@__PURE__*/ (function (_super) {
	    __extends(MergeScanSubscriber, _super);
	    function MergeScanSubscriber(destination, accumulator, acc, concurrent) {
	        var _this = _super.call(this, destination) || this;
	        _this.accumulator = accumulator;
	        _this.acc = acc;
	        _this.concurrent = concurrent;
	        _this.hasValue = false;
	        _this.hasCompleted = false;
	        _this.buffer = [];
	        _this.active = 0;
	        _this.index = 0;
	        return _this;
	    }
	    MergeScanSubscriber.prototype._next = function (value) {
	        if (this.active < this.concurrent) {
	            var index = this.index++;
	            var destination = this.destination;
	            var ish = void 0;
	            try {
	                var accumulator = this.accumulator;
	                ish = accumulator(this.acc, value, index);
	            }
	            catch (e) {
	                return destination.error(e);
	            }
	            this.active++;
	            this._innerSub(ish);
	        }
	        else {
	            this.buffer.push(value);
	        }
	    };
	    MergeScanSubscriber.prototype._innerSub = function (ish) {
	        var innerSubscriber = new SimpleInnerSubscriber(this);
	        var destination = this.destination;
	        destination.add(innerSubscriber);
	        var innerSubscription = innerSubscribe(ish, innerSubscriber);
	        if (innerSubscription !== innerSubscriber) {
	            destination.add(innerSubscription);
	        }
	    };
	    MergeScanSubscriber.prototype._complete = function () {
	        this.hasCompleted = true;
	        if (this.active === 0 && this.buffer.length === 0) {
	            if (this.hasValue === false) {
	                this.destination.next(this.acc);
	            }
	            this.destination.complete();
	        }
	        this.unsubscribe();
	    };
	    MergeScanSubscriber.prototype.notifyNext = function (innerValue) {
	        var destination = this.destination;
	        this.acc = innerValue;
	        this.hasValue = true;
	        destination.next(innerValue);
	    };
	    MergeScanSubscriber.prototype.notifyComplete = function () {
	        var buffer = this.buffer;
	        this.active--;
	        if (buffer.length > 0) {
	            this._next(buffer.shift());
	        }
	        else if (this.active === 0 && this.hasCompleted) {
	            if (this.hasValue === false) {
	                this.destination.next(this.acc);
	            }
	            this.destination.complete();
	        }
	    };
	    return MergeScanSubscriber;
	}(SimpleOuterSubscriber));

	/** PURE_IMPORTS_START _reduce PURE_IMPORTS_END */
	function min(comparer) {
	    var min = (typeof comparer === 'function')
	        ? function (x, y) { return comparer(x, y) < 0 ? x : y; }
	        : function (x, y) { return x < y ? x : y; };
	    return reduce(min);
	}

	/** PURE_IMPORTS_START tslib,_Subscriber PURE_IMPORTS_END */
	function refCount() {
	    return function refCountOperatorFunction(source) {
	        return source.lift(new RefCountOperator(source));
	    };
	}
	var RefCountOperator = /*@__PURE__*/ (function () {
	    function RefCountOperator(connectable) {
	        this.connectable = connectable;
	    }
	    RefCountOperator.prototype.call = function (subscriber, source) {
	        var connectable = this.connectable;
	        connectable._refCount++;
	        var refCounter = new RefCountSubscriber(subscriber, connectable);
	        var subscription = source.subscribe(refCounter);
	        if (!refCounter.closed) {
	            refCounter.connection = connectable.connect();
	        }
	        return subscription;
	    };
	    return RefCountOperator;
	}());
	var RefCountSubscriber = /*@__PURE__*/ (function (_super) {
	    __extends(RefCountSubscriber, _super);
	    function RefCountSubscriber(destination, connectable) {
	        var _this = _super.call(this, destination) || this;
	        _this.connectable = connectable;
	        return _this;
	    }
	    RefCountSubscriber.prototype._unsubscribe = function () {
	        var connectable = this.connectable;
	        if (!connectable) {
	            this.connection = null;
	            return;
	        }
	        this.connectable = null;
	        var refCount = connectable._refCount;
	        if (refCount <= 0) {
	            this.connection = null;
	            return;
	        }
	        connectable._refCount = refCount - 1;
	        if (refCount > 1) {
	            this.connection = null;
	            return;
	        }
	        var connection = this.connection;
	        var sharedConnection = connectable._connection;
	        this.connection = null;
	        if (sharedConnection && (!connection || sharedConnection === connection)) {
	            sharedConnection.unsubscribe();
	        }
	    };
	    return RefCountSubscriber;
	}(Subscriber));

	/** PURE_IMPORTS_START tslib,_Subject,_Observable,_Subscriber,_Subscription,_operators_refCount PURE_IMPORTS_END */
	var ConnectableObservable = /*@__PURE__*/ (function (_super) {
	    __extends(ConnectableObservable, _super);
	    function ConnectableObservable(source, subjectFactory) {
	        var _this = _super.call(this) || this;
	        _this.source = source;
	        _this.subjectFactory = subjectFactory;
	        _this._refCount = 0;
	        _this._isComplete = false;
	        return _this;
	    }
	    ConnectableObservable.prototype._subscribe = function (subscriber) {
	        return this.getSubject().subscribe(subscriber);
	    };
	    ConnectableObservable.prototype.getSubject = function () {
	        var subject = this._subject;
	        if (!subject || subject.isStopped) {
	            this._subject = this.subjectFactory();
	        }
	        return this._subject;
	    };
	    ConnectableObservable.prototype.connect = function () {
	        var connection = this._connection;
	        if (!connection) {
	            this._isComplete = false;
	            connection = this._connection = new Subscription();
	            connection.add(this.source
	                .subscribe(new ConnectableSubscriber(this.getSubject(), this)));
	            if (connection.closed) {
	                this._connection = null;
	                connection = Subscription.EMPTY;
	            }
	        }
	        return connection;
	    };
	    ConnectableObservable.prototype.refCount = function () {
	        return refCount()(this);
	    };
	    return ConnectableObservable;
	}(Observable));
	var connectableObservableDescriptor = /*@__PURE__*/ (function () {
	    var connectableProto = ConnectableObservable.prototype;
	    return {
	        operator: { value: null },
	        _refCount: { value: 0, writable: true },
	        _subject: { value: null, writable: true },
	        _connection: { value: null, writable: true },
	        _subscribe: { value: connectableProto._subscribe },
	        _isComplete: { value: connectableProto._isComplete, writable: true },
	        getSubject: { value: connectableProto.getSubject },
	        connect: { value: connectableProto.connect },
	        refCount: { value: connectableProto.refCount }
	    };
	})();
	var ConnectableSubscriber = /*@__PURE__*/ (function (_super) {
	    __extends(ConnectableSubscriber, _super);
	    function ConnectableSubscriber(destination, connectable) {
	        var _this = _super.call(this, destination) || this;
	        _this.connectable = connectable;
	        return _this;
	    }
	    ConnectableSubscriber.prototype._error = function (err) {
	        this._unsubscribe();
	        _super.prototype._error.call(this, err);
	    };
	    ConnectableSubscriber.prototype._complete = function () {
	        this.connectable._isComplete = true;
	        this._unsubscribe();
	        _super.prototype._complete.call(this);
	    };
	    ConnectableSubscriber.prototype._unsubscribe = function () {
	        var connectable = this.connectable;
	        if (connectable) {
	            this.connectable = null;
	            var connection = connectable._connection;
	            connectable._refCount = 0;
	            connectable._subject = null;
	            connectable._connection = null;
	            if (connection) {
	                connection.unsubscribe();
	            }
	        }
	    };
	    return ConnectableSubscriber;
	}(SubjectSubscriber));

	/** PURE_IMPORTS_START _observable_ConnectableObservable PURE_IMPORTS_END */
	function multicast(subjectOrSubjectFactory, selector) {
	    return function multicastOperatorFunction(source) {
	        var subjectFactory;
	        if (typeof subjectOrSubjectFactory === 'function') {
	            subjectFactory = subjectOrSubjectFactory;
	        }
	        else {
	            subjectFactory = function subjectFactory() {
	                return subjectOrSubjectFactory;
	            };
	        }
	        if (typeof selector === 'function') {
	            return source.lift(new MulticastOperator(subjectFactory, selector));
	        }
	        var connectable = Object.create(source, connectableObservableDescriptor);
	        connectable.source = source;
	        connectable.subjectFactory = subjectFactory;
	        return connectable;
	    };
	}
	var MulticastOperator = /*@__PURE__*/ (function () {
	    function MulticastOperator(subjectFactory, selector) {
	        this.subjectFactory = subjectFactory;
	        this.selector = selector;
	    }
	    MulticastOperator.prototype.call = function (subscriber, source) {
	        var selector = this.selector;
	        var subject = this.subjectFactory();
	        var subscription = selector(subject).subscribe(subscriber);
	        subscription.add(source.subscribe(subject));
	        return subscription;
	    };
	    return MulticastOperator;
	}());

	/** PURE_IMPORTS_START tslib,_observable_from,_util_isArray,_innerSubscribe PURE_IMPORTS_END */
	function onErrorResumeNext() {
	    var nextSources = [];
	    for (var _i = 0; _i < arguments.length; _i++) {
	        nextSources[_i] = arguments[_i];
	    }
	    if (nextSources.length === 1 && isArray(nextSources[0])) {
	        nextSources = nextSources[0];
	    }
	    return function (source) { return source.lift(new OnErrorResumeNextOperator(nextSources)); };
	}
	var OnErrorResumeNextOperator = /*@__PURE__*/ (function () {
	    function OnErrorResumeNextOperator(nextSources) {
	        this.nextSources = nextSources;
	    }
	    OnErrorResumeNextOperator.prototype.call = function (subscriber, source) {
	        return source.subscribe(new OnErrorResumeNextSubscriber(subscriber, this.nextSources));
	    };
	    return OnErrorResumeNextOperator;
	}());
	var OnErrorResumeNextSubscriber = /*@__PURE__*/ (function (_super) {
	    __extends(OnErrorResumeNextSubscriber, _super);
	    function OnErrorResumeNextSubscriber(destination, nextSources) {
	        var _this = _super.call(this, destination) || this;
	        _this.destination = destination;
	        _this.nextSources = nextSources;
	        return _this;
	    }
	    OnErrorResumeNextSubscriber.prototype.notifyError = function () {
	        this.subscribeToNextSource();
	    };
	    OnErrorResumeNextSubscriber.prototype.notifyComplete = function () {
	        this.subscribeToNextSource();
	    };
	    OnErrorResumeNextSubscriber.prototype._error = function (err) {
	        this.subscribeToNextSource();
	        this.unsubscribe();
	    };
	    OnErrorResumeNextSubscriber.prototype._complete = function () {
	        this.subscribeToNextSource();
	        this.unsubscribe();
	    };
	    OnErrorResumeNextSubscriber.prototype.subscribeToNextSource = function () {
	        var next = this.nextSources.shift();
	        if (!!next) {
	            var innerSubscriber = new SimpleInnerSubscriber(this);
	            var destination = this.destination;
	            destination.add(innerSubscriber);
	            var innerSubscription = innerSubscribe(next, innerSubscriber);
	            if (innerSubscription !== innerSubscriber) {
	                destination.add(innerSubscription);
	            }
	        }
	        else {
	            this.destination.complete();
	        }
	    };
	    return OnErrorResumeNextSubscriber;
	}(SimpleOuterSubscriber));

	/** PURE_IMPORTS_START tslib,_Subscriber PURE_IMPORTS_END */
	function pairwise() {
	    return function (source) { return source.lift(new PairwiseOperator()); };
	}
	var PairwiseOperator = /*@__PURE__*/ (function () {
	    function PairwiseOperator() {
	    }
	    PairwiseOperator.prototype.call = function (subscriber, source) {
	        return source.subscribe(new PairwiseSubscriber(subscriber));
	    };
	    return PairwiseOperator;
	}());
	var PairwiseSubscriber = /*@__PURE__*/ (function (_super) {
	    __extends(PairwiseSubscriber, _super);
	    function PairwiseSubscriber(destination) {
	        var _this = _super.call(this, destination) || this;
	        _this.hasPrev = false;
	        return _this;
	    }
	    PairwiseSubscriber.prototype._next = function (value) {
	        var pair;
	        if (this.hasPrev) {
	            pair = [this.prev, value];
	        }
	        else {
	            this.hasPrev = true;
	        }
	        this.prev = value;
	        if (pair) {
	            this.destination.next(pair);
	        }
	    };
	    return PairwiseSubscriber;
	}(Subscriber));

	/** PURE_IMPORTS_START  PURE_IMPORTS_END */
	function not(pred, thisArg) {
	    function notPred() {
	        return !(notPred.pred.apply(notPred.thisArg, arguments));
	    }
	    notPred.pred = pred;
	    notPred.thisArg = thisArg;
	    return notPred;
	}

	/** PURE_IMPORTS_START _util_not,_filter PURE_IMPORTS_END */
	function partition(predicate, thisArg) {
	    return function (source) {
	        return [
	            filter(predicate, thisArg)(source),
	            filter(not(predicate, thisArg))(source)
	        ];
	    };
	}

	/** PURE_IMPORTS_START _map PURE_IMPORTS_END */
	function pluck() {
	    var properties = [];
	    for (var _i = 0; _i < arguments.length; _i++) {
	        properties[_i] = arguments[_i];
	    }
	    var length = properties.length;
	    if (length === 0) {
	        throw new Error('list of properties cannot be empty.');
	    }
	    return function (source) { return map(plucker(properties, length))(source); };
	}
	function plucker(props, length) {
	    var mapper = function (x) {
	        var currentProp = x;
	        for (var i = 0; i < length; i++) {
	            var p = currentProp != null ? currentProp[props[i]] : undefined;
	            if (p !== void 0) {
	                currentProp = p;
	            }
	            else {
	                return undefined;
	            }
	        }
	        return currentProp;
	    };
	    return mapper;
	}

	/** PURE_IMPORTS_START _Subject,_multicast PURE_IMPORTS_END */
	function publish(selector) {
	    return selector ?
	        multicast(function () { return new Subject(); }, selector) :
	        multicast(new Subject());
	}

	/** PURE_IMPORTS_START tslib,_Subject,_util_ObjectUnsubscribedError PURE_IMPORTS_END */
	var BehaviorSubject = /*@__PURE__*/ (function (_super) {
	    __extends(BehaviorSubject, _super);
	    function BehaviorSubject(_value) {
	        var _this = _super.call(this) || this;
	        _this._value = _value;
	        return _this;
	    }
	    Object.defineProperty(BehaviorSubject.prototype, "value", {
	        get: function () {
	            return this.getValue();
	        },
	        enumerable: true,
	        configurable: true
	    });
	    BehaviorSubject.prototype._subscribe = function (subscriber) {
	        var subscription = _super.prototype._subscribe.call(this, subscriber);
	        if (subscription && !subscription.closed) {
	            subscriber.next(this._value);
	        }
	        return subscription;
	    };
	    BehaviorSubject.prototype.getValue = function () {
	        if (this.hasError) {
	            throw this.thrownError;
	        }
	        else if (this.closed) {
	            throw new ObjectUnsubscribedError();
	        }
	        else {
	            return this._value;
	        }
	    };
	    BehaviorSubject.prototype.next = function (value) {
	        _super.prototype.next.call(this, this._value = value);
	    };
	    return BehaviorSubject;
	}(Subject));

	/** PURE_IMPORTS_START _BehaviorSubject,_multicast PURE_IMPORTS_END */
	function publishBehavior(value) {
	    return function (source) { return multicast(new BehaviorSubject(value))(source); };
	}

	/** PURE_IMPORTS_START tslib,_Subject,_Subscription PURE_IMPORTS_END */
	var AsyncSubject = /*@__PURE__*/ (function (_super) {
	    __extends(AsyncSubject, _super);
	    function AsyncSubject() {
	        var _this = _super !== null && _super.apply(this, arguments) || this;
	        _this.value = null;
	        _this.hasNext = false;
	        _this.hasCompleted = false;
	        return _this;
	    }
	    AsyncSubject.prototype._subscribe = function (subscriber) {
	        if (this.hasError) {
	            subscriber.error(this.thrownError);
	            return Subscription.EMPTY;
	        }
	        else if (this.hasCompleted && this.hasNext) {
	            subscriber.next(this.value);
	            subscriber.complete();
	            return Subscription.EMPTY;
	        }
	        return _super.prototype._subscribe.call(this, subscriber);
	    };
	    AsyncSubject.prototype.next = function (value) {
	        if (!this.hasCompleted) {
	            this.value = value;
	            this.hasNext = true;
	        }
	    };
	    AsyncSubject.prototype.error = function (error) {
	        if (!this.hasCompleted) {
	            _super.prototype.error.call(this, error);
	        }
	    };
	    AsyncSubject.prototype.complete = function () {
	        this.hasCompleted = true;
	        if (this.hasNext) {
	            _super.prototype.next.call(this, this.value);
	        }
	        _super.prototype.complete.call(this);
	    };
	    return AsyncSubject;
	}(Subject));

	/** PURE_IMPORTS_START _AsyncSubject,_multicast PURE_IMPORTS_END */
	function publishLast() {
	    return function (source) { return multicast(new AsyncSubject())(source); };
	}

	/** PURE_IMPORTS_START _ReplaySubject,_multicast PURE_IMPORTS_END */
	function publishReplay(bufferSize, windowTime, selectorOrScheduler, scheduler) {
	    if (selectorOrScheduler && typeof selectorOrScheduler !== 'function') {
	        scheduler = selectorOrScheduler;
	    }
	    var selector = typeof selectorOrScheduler === 'function' ? selectorOrScheduler : undefined;
	    var subject = new ReplaySubject(bufferSize, windowTime, scheduler);
	    return function (source) { return multicast(function () { return subject; }, selector)(source); };
	}

	/** PURE_IMPORTS_START tslib,_util_isArray,_fromArray,_OuterSubscriber,_util_subscribeToResult PURE_IMPORTS_END */
	function race$1() {
	    var observables = [];
	    for (var _i = 0; _i < arguments.length; _i++) {
	        observables[_i] = arguments[_i];
	    }
	    if (observables.length === 1) {
	        if (isArray(observables[0])) {
	            observables = observables[0];
	        }
	        else {
	            return observables[0];
	        }
	    }
	    return fromArray(observables, undefined).lift(new RaceOperator());
	}
	var RaceOperator = /*@__PURE__*/ (function () {
	    function RaceOperator() {
	    }
	    RaceOperator.prototype.call = function (subscriber, source) {
	        return source.subscribe(new RaceSubscriber(subscriber));
	    };
	    return RaceOperator;
	}());
	var RaceSubscriber = /*@__PURE__*/ (function (_super) {
	    __extends(RaceSubscriber, _super);
	    function RaceSubscriber(destination) {
	        var _this = _super.call(this, destination) || this;
	        _this.hasFirst = false;
	        _this.observables = [];
	        _this.subscriptions = [];
	        return _this;
	    }
	    RaceSubscriber.prototype._next = function (observable) {
	        this.observables.push(observable);
	    };
	    RaceSubscriber.prototype._complete = function () {
	        var observables = this.observables;
	        var len = observables.length;
	        if (len === 0) {
	            this.destination.complete();
	        }
	        else {
	            for (var i = 0; i < len && !this.hasFirst; i++) {
	                var observable = observables[i];
	                var subscription = subscribeToResult(this, observable, undefined, i);
	                if (this.subscriptions) {
	                    this.subscriptions.push(subscription);
	                }
	                this.add(subscription);
	            }
	            this.observables = null;
	        }
	    };
	    RaceSubscriber.prototype.notifyNext = function (_outerValue, innerValue, outerIndex) {
	        if (!this.hasFirst) {
	            this.hasFirst = true;
	            for (var i = 0; i < this.subscriptions.length; i++) {
	                if (i !== outerIndex) {
	                    var subscription = this.subscriptions[i];
	                    subscription.unsubscribe();
	                    this.remove(subscription);
	                }
	            }
	            this.subscriptions = null;
	        }
	        this.destination.next(innerValue);
	    };
	    return RaceSubscriber;
	}(OuterSubscriber));

	/** PURE_IMPORTS_START _util_isArray,_observable_race PURE_IMPORTS_END */
	function race() {
	    var observables = [];
	    for (var _i = 0; _i < arguments.length; _i++) {
	        observables[_i] = arguments[_i];
	    }
	    return function raceOperatorFunction(source) {
	        if (observables.length === 1 && isArray(observables[0])) {
	            observables = observables[0];
	        }
	        return source.lift.call(race$1.apply(void 0, [source].concat(observables)));
	    };
	}

	/** PURE_IMPORTS_START tslib,_Subscriber,_observable_empty PURE_IMPORTS_END */
	function repeat(count) {
	    if (count === void 0) {
	        count = -1;
	    }
	    return function (source) {
	        if (count === 0) {
	            return empty();
	        }
	        else if (count < 0) {
	            return source.lift(new RepeatOperator(-1, source));
	        }
	        else {
	            return source.lift(new RepeatOperator(count - 1, source));
	        }
	    };
	}
	var RepeatOperator = /*@__PURE__*/ (function () {
	    function RepeatOperator(count, source) {
	        this.count = count;
	        this.source = source;
	    }
	    RepeatOperator.prototype.call = function (subscriber, source) {
	        return source.subscribe(new RepeatSubscriber(subscriber, this.count, this.source));
	    };
	    return RepeatOperator;
	}());
	var RepeatSubscriber = /*@__PURE__*/ (function (_super) {
	    __extends(RepeatSubscriber, _super);
	    function RepeatSubscriber(destination, count, source) {
	        var _this = _super.call(this, destination) || this;
	        _this.count = count;
	        _this.source = source;
	        return _this;
	    }
	    RepeatSubscriber.prototype.complete = function () {
	        if (!this.isStopped) {
	            var _a = this, source = _a.source, count = _a.count;
	            if (count === 0) {
	                return _super.prototype.complete.call(this);
	            }
	            else if (count > -1) {
	                this.count = count - 1;
	            }
	            source.subscribe(this._unsubscribeAndRecycle());
	        }
	    };
	    return RepeatSubscriber;
	}(Subscriber));

	/** PURE_IMPORTS_START tslib,_Subject,_innerSubscribe PURE_IMPORTS_END */
	function repeatWhen(notifier) {
	    return function (source) { return source.lift(new RepeatWhenOperator(notifier)); };
	}
	var RepeatWhenOperator = /*@__PURE__*/ (function () {
	    function RepeatWhenOperator(notifier) {
	        this.notifier = notifier;
	    }
	    RepeatWhenOperator.prototype.call = function (subscriber, source) {
	        return source.subscribe(new RepeatWhenSubscriber(subscriber, this.notifier, source));
	    };
	    return RepeatWhenOperator;
	}());
	var RepeatWhenSubscriber = /*@__PURE__*/ (function (_super) {
	    __extends(RepeatWhenSubscriber, _super);
	    function RepeatWhenSubscriber(destination, notifier, source) {
	        var _this = _super.call(this, destination) || this;
	        _this.notifier = notifier;
	        _this.source = source;
	        _this.sourceIsBeingSubscribedTo = true;
	        return _this;
	    }
	    RepeatWhenSubscriber.prototype.notifyNext = function () {
	        this.sourceIsBeingSubscribedTo = true;
	        this.source.subscribe(this);
	    };
	    RepeatWhenSubscriber.prototype.notifyComplete = function () {
	        if (this.sourceIsBeingSubscribedTo === false) {
	            return _super.prototype.complete.call(this);
	        }
	    };
	    RepeatWhenSubscriber.prototype.complete = function () {
	        this.sourceIsBeingSubscribedTo = false;
	        if (!this.isStopped) {
	            if (!this.retries) {
	                this.subscribeToRetries();
	            }
	            if (!this.retriesSubscription || this.retriesSubscription.closed) {
	                return _super.prototype.complete.call(this);
	            }
	            this._unsubscribeAndRecycle();
	            this.notifications.next(undefined);
	        }
	    };
	    RepeatWhenSubscriber.prototype._unsubscribe = function () {
	        var _a = this, notifications = _a.notifications, retriesSubscription = _a.retriesSubscription;
	        if (notifications) {
	            notifications.unsubscribe();
	            this.notifications = undefined;
	        }
	        if (retriesSubscription) {
	            retriesSubscription.unsubscribe();
	            this.retriesSubscription = undefined;
	        }
	        this.retries = undefined;
	    };
	    RepeatWhenSubscriber.prototype._unsubscribeAndRecycle = function () {
	        var _unsubscribe = this._unsubscribe;
	        this._unsubscribe = null;
	        _super.prototype._unsubscribeAndRecycle.call(this);
	        this._unsubscribe = _unsubscribe;
	        return this;
	    };
	    RepeatWhenSubscriber.prototype.subscribeToRetries = function () {
	        this.notifications = new Subject();
	        var retries;
	        try {
	            var notifier = this.notifier;
	            retries = notifier(this.notifications);
	        }
	        catch (e) {
	            return _super.prototype.complete.call(this);
	        }
	        this.retries = retries;
	        this.retriesSubscription = innerSubscribe(retries, new SimpleInnerSubscriber(this));
	    };
	    return RepeatWhenSubscriber;
	}(SimpleOuterSubscriber));

	/** PURE_IMPORTS_START tslib,_Subscriber PURE_IMPORTS_END */
	function retry(count) {
	    if (count === void 0) {
	        count = -1;
	    }
	    return function (source) { return source.lift(new RetryOperator(count, source)); };
	}
	var RetryOperator = /*@__PURE__*/ (function () {
	    function RetryOperator(count, source) {
	        this.count = count;
	        this.source = source;
	    }
	    RetryOperator.prototype.call = function (subscriber, source) {
	        return source.subscribe(new RetrySubscriber(subscriber, this.count, this.source));
	    };
	    return RetryOperator;
	}());
	var RetrySubscriber = /*@__PURE__*/ (function (_super) {
	    __extends(RetrySubscriber, _super);
	    function RetrySubscriber(destination, count, source) {
	        var _this = _super.call(this, destination) || this;
	        _this.count = count;
	        _this.source = source;
	        return _this;
	    }
	    RetrySubscriber.prototype.error = function (err) {
	        if (!this.isStopped) {
	            var _a = this, source = _a.source, count = _a.count;
	            if (count === 0) {
	                return _super.prototype.error.call(this, err);
	            }
	            else if (count > -1) {
	                this.count = count - 1;
	            }
	            source.subscribe(this._unsubscribeAndRecycle());
	        }
	    };
	    return RetrySubscriber;
	}(Subscriber));

	/** PURE_IMPORTS_START tslib,_Subject,_innerSubscribe PURE_IMPORTS_END */
	function retryWhen(notifier) {
	    return function (source) { return source.lift(new RetryWhenOperator(notifier, source)); };
	}
	var RetryWhenOperator = /*@__PURE__*/ (function () {
	    function RetryWhenOperator(notifier, source) {
	        this.notifier = notifier;
	        this.source = source;
	    }
	    RetryWhenOperator.prototype.call = function (subscriber, source) {
	        return source.subscribe(new RetryWhenSubscriber(subscriber, this.notifier, this.source));
	    };
	    return RetryWhenOperator;
	}());
	var RetryWhenSubscriber = /*@__PURE__*/ (function (_super) {
	    __extends(RetryWhenSubscriber, _super);
	    function RetryWhenSubscriber(destination, notifier, source) {
	        var _this = _super.call(this, destination) || this;
	        _this.notifier = notifier;
	        _this.source = source;
	        return _this;
	    }
	    RetryWhenSubscriber.prototype.error = function (err) {
	        if (!this.isStopped) {
	            var errors = this.errors;
	            var retries = this.retries;
	            var retriesSubscription = this.retriesSubscription;
	            if (!retries) {
	                errors = new Subject();
	                try {
	                    var notifier = this.notifier;
	                    retries = notifier(errors);
	                }
	                catch (e) {
	                    return _super.prototype.error.call(this, e);
	                }
	                retriesSubscription = innerSubscribe(retries, new SimpleInnerSubscriber(this));
	            }
	            else {
	                this.errors = undefined;
	                this.retriesSubscription = undefined;
	            }
	            this._unsubscribeAndRecycle();
	            this.errors = errors;
	            this.retries = retries;
	            this.retriesSubscription = retriesSubscription;
	            errors.next(err);
	        }
	    };
	    RetryWhenSubscriber.prototype._unsubscribe = function () {
	        var _a = this, errors = _a.errors, retriesSubscription = _a.retriesSubscription;
	        if (errors) {
	            errors.unsubscribe();
	            this.errors = undefined;
	        }
	        if (retriesSubscription) {
	            retriesSubscription.unsubscribe();
	            this.retriesSubscription = undefined;
	        }
	        this.retries = undefined;
	    };
	    RetryWhenSubscriber.prototype.notifyNext = function () {
	        var _unsubscribe = this._unsubscribe;
	        this._unsubscribe = null;
	        this._unsubscribeAndRecycle();
	        this._unsubscribe = _unsubscribe;
	        this.source.subscribe(this);
	    };
	    return RetryWhenSubscriber;
	}(SimpleOuterSubscriber));

	/** PURE_IMPORTS_START tslib,_innerSubscribe PURE_IMPORTS_END */
	function sample(notifier) {
	    return function (source) { return source.lift(new SampleOperator(notifier)); };
	}
	var SampleOperator = /*@__PURE__*/ (function () {
	    function SampleOperator(notifier) {
	        this.notifier = notifier;
	    }
	    SampleOperator.prototype.call = function (subscriber, source) {
	        var sampleSubscriber = new SampleSubscriber(subscriber);
	        var subscription = source.subscribe(sampleSubscriber);
	        subscription.add(innerSubscribe(this.notifier, new SimpleInnerSubscriber(sampleSubscriber)));
	        return subscription;
	    };
	    return SampleOperator;
	}());
	var SampleSubscriber = /*@__PURE__*/ (function (_super) {
	    __extends(SampleSubscriber, _super);
	    function SampleSubscriber() {
	        var _this = _super !== null && _super.apply(this, arguments) || this;
	        _this.hasValue = false;
	        return _this;
	    }
	    SampleSubscriber.prototype._next = function (value) {
	        this.value = value;
	        this.hasValue = true;
	    };
	    SampleSubscriber.prototype.notifyNext = function () {
	        this.emitValue();
	    };
	    SampleSubscriber.prototype.notifyComplete = function () {
	        this.emitValue();
	    };
	    SampleSubscriber.prototype.emitValue = function () {
	        if (this.hasValue) {
	            this.hasValue = false;
	            this.destination.next(this.value);
	        }
	    };
	    return SampleSubscriber;
	}(SimpleOuterSubscriber));

	/** PURE_IMPORTS_START tslib,_Subscriber,_scheduler_async PURE_IMPORTS_END */
	function sampleTime(period, scheduler) {
	    if (scheduler === void 0) {
	        scheduler = async;
	    }
	    return function (source) { return source.lift(new SampleTimeOperator(period, scheduler)); };
	}
	var SampleTimeOperator = /*@__PURE__*/ (function () {
	    function SampleTimeOperator(period, scheduler) {
	        this.period = period;
	        this.scheduler = scheduler;
	    }
	    SampleTimeOperator.prototype.call = function (subscriber, source) {
	        return source.subscribe(new SampleTimeSubscriber(subscriber, this.period, this.scheduler));
	    };
	    return SampleTimeOperator;
	}());
	var SampleTimeSubscriber = /*@__PURE__*/ (function (_super) {
	    __extends(SampleTimeSubscriber, _super);
	    function SampleTimeSubscriber(destination, period, scheduler) {
	        var _this = _super.call(this, destination) || this;
	        _this.period = period;
	        _this.scheduler = scheduler;
	        _this.hasValue = false;
	        _this.add(scheduler.schedule(dispatchNotification, period, { subscriber: _this, period: period }));
	        return _this;
	    }
	    SampleTimeSubscriber.prototype._next = function (value) {
	        this.lastValue = value;
	        this.hasValue = true;
	    };
	    SampleTimeSubscriber.prototype.notifyNext = function () {
	        if (this.hasValue) {
	            this.hasValue = false;
	            this.destination.next(this.lastValue);
	        }
	    };
	    return SampleTimeSubscriber;
	}(Subscriber));
	function dispatchNotification(state) {
	    var subscriber = state.subscriber, period = state.period;
	    subscriber.notifyNext();
	    this.schedule(state, period);
	}

	/** PURE_IMPORTS_START tslib,_Subscriber PURE_IMPORTS_END */
	function sequenceEqual(compareTo, comparator) {
	    return function (source) { return source.lift(new SequenceEqualOperator(compareTo, comparator)); };
	}
	var SequenceEqualOperator = /*@__PURE__*/ (function () {
	    function SequenceEqualOperator(compareTo, comparator) {
	        this.compareTo = compareTo;
	        this.comparator = comparator;
	    }
	    SequenceEqualOperator.prototype.call = function (subscriber, source) {
	        return source.subscribe(new SequenceEqualSubscriber(subscriber, this.compareTo, this.comparator));
	    };
	    return SequenceEqualOperator;
	}());
	var SequenceEqualSubscriber = /*@__PURE__*/ (function (_super) {
	    __extends(SequenceEqualSubscriber, _super);
	    function SequenceEqualSubscriber(destination, compareTo, comparator) {
	        var _this = _super.call(this, destination) || this;
	        _this.compareTo = compareTo;
	        _this.comparator = comparator;
	        _this._a = [];
	        _this._b = [];
	        _this._oneComplete = false;
	        _this.destination.add(compareTo.subscribe(new SequenceEqualCompareToSubscriber(destination, _this)));
	        return _this;
	    }
	    SequenceEqualSubscriber.prototype._next = function (value) {
	        if (this._oneComplete && this._b.length === 0) {
	            this.emit(false);
	        }
	        else {
	            this._a.push(value);
	            this.checkValues();
	        }
	    };
	    SequenceEqualSubscriber.prototype._complete = function () {
	        if (this._oneComplete) {
	            this.emit(this._a.length === 0 && this._b.length === 0);
	        }
	        else {
	            this._oneComplete = true;
	        }
	        this.unsubscribe();
	    };
	    SequenceEqualSubscriber.prototype.checkValues = function () {
	        var _c = this, _a = _c._a, _b = _c._b, comparator = _c.comparator;
	        while (_a.length > 0 && _b.length > 0) {
	            var a = _a.shift();
	            var b = _b.shift();
	            var areEqual = false;
	            try {
	                areEqual = comparator ? comparator(a, b) : a === b;
	            }
	            catch (e) {
	                this.destination.error(e);
	            }
	            if (!areEqual) {
	                this.emit(false);
	            }
	        }
	    };
	    SequenceEqualSubscriber.prototype.emit = function (value) {
	        var destination = this.destination;
	        destination.next(value);
	        destination.complete();
	    };
	    SequenceEqualSubscriber.prototype.nextB = function (value) {
	        if (this._oneComplete && this._a.length === 0) {
	            this.emit(false);
	        }
	        else {
	            this._b.push(value);
	            this.checkValues();
	        }
	    };
	    SequenceEqualSubscriber.prototype.completeB = function () {
	        if (this._oneComplete) {
	            this.emit(this._a.length === 0 && this._b.length === 0);
	        }
	        else {
	            this._oneComplete = true;
	        }
	    };
	    return SequenceEqualSubscriber;
	}(Subscriber));
	var SequenceEqualCompareToSubscriber = /*@__PURE__*/ (function (_super) {
	    __extends(SequenceEqualCompareToSubscriber, _super);
	    function SequenceEqualCompareToSubscriber(destination, parent) {
	        var _this = _super.call(this, destination) || this;
	        _this.parent = parent;
	        return _this;
	    }
	    SequenceEqualCompareToSubscriber.prototype._next = function (value) {
	        this.parent.nextB(value);
	    };
	    SequenceEqualCompareToSubscriber.prototype._error = function (err) {
	        this.parent.error(err);
	        this.unsubscribe();
	    };
	    SequenceEqualCompareToSubscriber.prototype._complete = function () {
	        this.parent.completeB();
	        this.unsubscribe();
	    };
	    return SequenceEqualCompareToSubscriber;
	}(Subscriber));

	/** PURE_IMPORTS_START _multicast,_refCount,_Subject PURE_IMPORTS_END */
	function shareSubjectFactory() {
	    return new Subject();
	}
	function share() {
	    return function (source) { return refCount()(multicast(shareSubjectFactory)(source)); };
	}

	/** PURE_IMPORTS_START _ReplaySubject PURE_IMPORTS_END */
	function shareReplay(configOrBufferSize, windowTime, scheduler) {
	    var config;
	    if (configOrBufferSize && typeof configOrBufferSize === 'object') {
	        config = configOrBufferSize;
	    }
	    else {
	        config = {
	            bufferSize: configOrBufferSize,
	            windowTime: windowTime,
	            refCount: false,
	            scheduler: scheduler,
	        };
	    }
	    return function (source) { return source.lift(shareReplayOperator(config)); };
	}
	function shareReplayOperator(_a) {
	    var _b = _a.bufferSize, bufferSize = _b === void 0 ? Number.POSITIVE_INFINITY : _b, _c = _a.windowTime, windowTime = _c === void 0 ? Number.POSITIVE_INFINITY : _c, useRefCount = _a.refCount, scheduler = _a.scheduler;
	    var subject;
	    var refCount = 0;
	    var subscription;
	    var hasError = false;
	    var isComplete = false;
	    return function shareReplayOperation(source) {
	        refCount++;
	        var innerSub;
	        if (!subject || hasError) {
	            hasError = false;
	            subject = new ReplaySubject(bufferSize, windowTime, scheduler);
	            innerSub = subject.subscribe(this);
	            subscription = source.subscribe({
	                next: function (value) {
	                    subject.next(value);
	                },
	                error: function (err) {
	                    hasError = true;
	                    subject.error(err);
	                },
	                complete: function () {
	                    isComplete = true;
	                    subscription = undefined;
	                    subject.complete();
	                },
	            });
	            if (isComplete) {
	                subscription = undefined;
	            }
	        }
	        else {
	            innerSub = subject.subscribe(this);
	        }
	        this.add(function () {
	            refCount--;
	            innerSub.unsubscribe();
	            innerSub = undefined;
	            if (subscription && !isComplete && useRefCount && refCount === 0) {
	                subscription.unsubscribe();
	                subscription = undefined;
	                subject = undefined;
	            }
	        });
	    };
	}

	/** PURE_IMPORTS_START tslib,_Subscriber,_util_EmptyError PURE_IMPORTS_END */
	function single(predicate) {
	    return function (source) { return source.lift(new SingleOperator(predicate, source)); };
	}
	var SingleOperator = /*@__PURE__*/ (function () {
	    function SingleOperator(predicate, source) {
	        this.predicate = predicate;
	        this.source = source;
	    }
	    SingleOperator.prototype.call = function (subscriber, source) {
	        return source.subscribe(new SingleSubscriber(subscriber, this.predicate, this.source));
	    };
	    return SingleOperator;
	}());
	var SingleSubscriber = /*@__PURE__*/ (function (_super) {
	    __extends(SingleSubscriber, _super);
	    function SingleSubscriber(destination, predicate, source) {
	        var _this = _super.call(this, destination) || this;
	        _this.predicate = predicate;
	        _this.source = source;
	        _this.seenValue = false;
	        _this.index = 0;
	        return _this;
	    }
	    SingleSubscriber.prototype.applySingleValue = function (value) {
	        if (this.seenValue) {
	            this.destination.error('Sequence contains more than one element');
	        }
	        else {
	            this.seenValue = true;
	            this.singleValue = value;
	        }
	    };
	    SingleSubscriber.prototype._next = function (value) {
	        var index = this.index++;
	        if (this.predicate) {
	            this.tryNext(value, index);
	        }
	        else {
	            this.applySingleValue(value);
	        }
	    };
	    SingleSubscriber.prototype.tryNext = function (value, index) {
	        try {
	            if (this.predicate(value, index, this.source)) {
	                this.applySingleValue(value);
	            }
	        }
	        catch (err) {
	            this.destination.error(err);
	        }
	    };
	    SingleSubscriber.prototype._complete = function () {
	        var destination = this.destination;
	        if (this.index > 0) {
	            destination.next(this.seenValue ? this.singleValue : undefined);
	            destination.complete();
	        }
	        else {
	            destination.error(new EmptyError);
	        }
	    };
	    return SingleSubscriber;
	}(Subscriber));

	/** PURE_IMPORTS_START tslib,_Subscriber PURE_IMPORTS_END */
	function skip(count) {
	    return function (source) { return source.lift(new SkipOperator(count)); };
	}
	var SkipOperator = /*@__PURE__*/ (function () {
	    function SkipOperator(total) {
	        this.total = total;
	    }
	    SkipOperator.prototype.call = function (subscriber, source) {
	        return source.subscribe(new SkipSubscriber(subscriber, this.total));
	    };
	    return SkipOperator;
	}());
	var SkipSubscriber = /*@__PURE__*/ (function (_super) {
	    __extends(SkipSubscriber, _super);
	    function SkipSubscriber(destination, total) {
	        var _this = _super.call(this, destination) || this;
	        _this.total = total;
	        _this.count = 0;
	        return _this;
	    }
	    SkipSubscriber.prototype._next = function (x) {
	        if (++this.count > this.total) {
	            this.destination.next(x);
	        }
	    };
	    return SkipSubscriber;
	}(Subscriber));

	/** PURE_IMPORTS_START tslib,_Subscriber,_util_ArgumentOutOfRangeError PURE_IMPORTS_END */
	function skipLast(count) {
	    return function (source) { return source.lift(new SkipLastOperator(count)); };
	}
	var SkipLastOperator = /*@__PURE__*/ (function () {
	    function SkipLastOperator(_skipCount) {
	        this._skipCount = _skipCount;
	        if (this._skipCount < 0) {
	            throw new ArgumentOutOfRangeError;
	        }
	    }
	    SkipLastOperator.prototype.call = function (subscriber, source) {
	        if (this._skipCount === 0) {
	            return source.subscribe(new Subscriber(subscriber));
	        }
	        else {
	            return source.subscribe(new SkipLastSubscriber(subscriber, this._skipCount));
	        }
	    };
	    return SkipLastOperator;
	}());
	var SkipLastSubscriber = /*@__PURE__*/ (function (_super) {
	    __extends(SkipLastSubscriber, _super);
	    function SkipLastSubscriber(destination, _skipCount) {
	        var _this = _super.call(this, destination) || this;
	        _this._skipCount = _skipCount;
	        _this._count = 0;
	        _this._ring = new Array(_skipCount);
	        return _this;
	    }
	    SkipLastSubscriber.prototype._next = function (value) {
	        var skipCount = this._skipCount;
	        var count = this._count++;
	        if (count < skipCount) {
	            this._ring[count] = value;
	        }
	        else {
	            var currentIndex = count % skipCount;
	            var ring = this._ring;
	            var oldValue = ring[currentIndex];
	            ring[currentIndex] = value;
	            this.destination.next(oldValue);
	        }
	    };
	    return SkipLastSubscriber;
	}(Subscriber));

	/** PURE_IMPORTS_START tslib,_innerSubscribe PURE_IMPORTS_END */
	function skipUntil(notifier) {
	    return function (source) { return source.lift(new SkipUntilOperator(notifier)); };
	}
	var SkipUntilOperator = /*@__PURE__*/ (function () {
	    function SkipUntilOperator(notifier) {
	        this.notifier = notifier;
	    }
	    SkipUntilOperator.prototype.call = function (destination, source) {
	        return source.subscribe(new SkipUntilSubscriber(destination, this.notifier));
	    };
	    return SkipUntilOperator;
	}());
	var SkipUntilSubscriber = /*@__PURE__*/ (function (_super) {
	    __extends(SkipUntilSubscriber, _super);
	    function SkipUntilSubscriber(destination, notifier) {
	        var _this = _super.call(this, destination) || this;
	        _this.hasValue = false;
	        var innerSubscriber = new SimpleInnerSubscriber(_this);
	        _this.add(innerSubscriber);
	        _this.innerSubscription = innerSubscriber;
	        var innerSubscription = innerSubscribe(notifier, innerSubscriber);
	        if (innerSubscription !== innerSubscriber) {
	            _this.add(innerSubscription);
	            _this.innerSubscription = innerSubscription;
	        }
	        return _this;
	    }
	    SkipUntilSubscriber.prototype._next = function (value) {
	        if (this.hasValue) {
	            _super.prototype._next.call(this, value);
	        }
	    };
	    SkipUntilSubscriber.prototype.notifyNext = function () {
	        this.hasValue = true;
	        if (this.innerSubscription) {
	            this.innerSubscription.unsubscribe();
	        }
	    };
	    SkipUntilSubscriber.prototype.notifyComplete = function () {
	    };
	    return SkipUntilSubscriber;
	}(SimpleOuterSubscriber));

	/** PURE_IMPORTS_START tslib,_Subscriber PURE_IMPORTS_END */
	function skipWhile(predicate) {
	    return function (source) { return source.lift(new SkipWhileOperator(predicate)); };
	}
	var SkipWhileOperator = /*@__PURE__*/ (function () {
	    function SkipWhileOperator(predicate) {
	        this.predicate = predicate;
	    }
	    SkipWhileOperator.prototype.call = function (subscriber, source) {
	        return source.subscribe(new SkipWhileSubscriber(subscriber, this.predicate));
	    };
	    return SkipWhileOperator;
	}());
	var SkipWhileSubscriber = /*@__PURE__*/ (function (_super) {
	    __extends(SkipWhileSubscriber, _super);
	    function SkipWhileSubscriber(destination, predicate) {
	        var _this = _super.call(this, destination) || this;
	        _this.predicate = predicate;
	        _this.skipping = true;
	        _this.index = 0;
	        return _this;
	    }
	    SkipWhileSubscriber.prototype._next = function (value) {
	        var destination = this.destination;
	        if (this.skipping) {
	            this.tryCallPredicate(value);
	        }
	        if (!this.skipping) {
	            destination.next(value);
	        }
	    };
	    SkipWhileSubscriber.prototype.tryCallPredicate = function (value) {
	        try {
	            var result = this.predicate(value, this.index++);
	            this.skipping = Boolean(result);
	        }
	        catch (err) {
	            this.destination.error(err);
	        }
	    };
	    return SkipWhileSubscriber;
	}(Subscriber));

	/** PURE_IMPORTS_START _observable_concat,_util_isScheduler PURE_IMPORTS_END */
	function startWith() {
	    var array = [];
	    for (var _i = 0; _i < arguments.length; _i++) {
	        array[_i] = arguments[_i];
	    }
	    var scheduler = array[array.length - 1];
	    if (isScheduler(scheduler)) {
	        array.pop();
	        return function (source) { return concat$1(array, source, scheduler); };
	    }
	    else {
	        return function (source) { return concat$1(array, source); };
	    }
	}

	/** PURE_IMPORTS_START  PURE_IMPORTS_END */
	var nextHandle = 1;
	var RESOLVED = /*@__PURE__*/ (function () { return /*@__PURE__*/ Promise.resolve(); })();
	var activeHandles = {};
	function findAndClearHandle(handle) {
	    if (handle in activeHandles) {
	        delete activeHandles[handle];
	        return true;
	    }
	    return false;
	}
	var Immediate = {
	    setImmediate: function (cb) {
	        var handle = nextHandle++;
	        activeHandles[handle] = true;
	        RESOLVED.then(function () { return findAndClearHandle(handle) && cb(); });
	        return handle;
	    },
	    clearImmediate: function (handle) {
	        findAndClearHandle(handle);
	    },
	};

	/** PURE_IMPORTS_START tslib,_util_Immediate,_AsyncAction PURE_IMPORTS_END */
	var AsapAction = /*@__PURE__*/ (function (_super) {
	    __extends(AsapAction, _super);
	    function AsapAction(scheduler, work) {
	        var _this = _super.call(this, scheduler, work) || this;
	        _this.scheduler = scheduler;
	        _this.work = work;
	        return _this;
	    }
	    AsapAction.prototype.requestAsyncId = function (scheduler, id, delay) {
	        if (delay === void 0) {
	            delay = 0;
	        }
	        if (delay !== null && delay > 0) {
	            return _super.prototype.requestAsyncId.call(this, scheduler, id, delay);
	        }
	        scheduler.actions.push(this);
	        return scheduler.scheduled || (scheduler.scheduled = Immediate.setImmediate(scheduler.flush.bind(scheduler, null)));
	    };
	    AsapAction.prototype.recycleAsyncId = function (scheduler, id, delay) {
	        if (delay === void 0) {
	            delay = 0;
	        }
	        if ((delay !== null && delay > 0) || (delay === null && this.delay > 0)) {
	            return _super.prototype.recycleAsyncId.call(this, scheduler, id, delay);
	        }
	        if (scheduler.actions.length === 0) {
	            Immediate.clearImmediate(id);
	            scheduler.scheduled = undefined;
	        }
	        return undefined;
	    };
	    return AsapAction;
	}(AsyncAction));

	/** PURE_IMPORTS_START tslib,_AsyncScheduler PURE_IMPORTS_END */
	var AsapScheduler = /*@__PURE__*/ (function (_super) {
	    __extends(AsapScheduler, _super);
	    function AsapScheduler() {
	        return _super !== null && _super.apply(this, arguments) || this;
	    }
	    AsapScheduler.prototype.flush = function (action) {
	        this.active = true;
	        this.scheduled = undefined;
	        var actions = this.actions;
	        var error;
	        var index = -1;
	        var count = actions.length;
	        action = action || actions.shift();
	        do {
	            if (error = action.execute(action.state, action.delay)) {
	                break;
	            }
	        } while (++index < count && (action = actions.shift()));
	        this.active = false;
	        if (error) {
	            while (++index < count && (action = actions.shift())) {
	                action.unsubscribe();
	            }
	            throw error;
	        }
	    };
	    return AsapScheduler;
	}(AsyncScheduler));

	/** PURE_IMPORTS_START _AsapAction,_AsapScheduler PURE_IMPORTS_END */
	var asapScheduler = /*@__PURE__*/ new AsapScheduler(AsapAction);
	var asap = asapScheduler;

	/** PURE_IMPORTS_START tslib,_Observable,_scheduler_asap,_util_isNumeric PURE_IMPORTS_END */
	var SubscribeOnObservable = /*@__PURE__*/ (function (_super) {
	    __extends(SubscribeOnObservable, _super);
	    function SubscribeOnObservable(source, delayTime, scheduler) {
	        if (delayTime === void 0) {
	            delayTime = 0;
	        }
	        if (scheduler === void 0) {
	            scheduler = asap;
	        }
	        var _this = _super.call(this) || this;
	        _this.source = source;
	        _this.delayTime = delayTime;
	        _this.scheduler = scheduler;
	        if (!isNumeric(delayTime) || delayTime < 0) {
	            _this.delayTime = 0;
	        }
	        if (!scheduler || typeof scheduler.schedule !== 'function') {
	            _this.scheduler = asap;
	        }
	        return _this;
	    }
	    SubscribeOnObservable.create = function (source, delay, scheduler) {
	        if (delay === void 0) {
	            delay = 0;
	        }
	        if (scheduler === void 0) {
	            scheduler = asap;
	        }
	        return new SubscribeOnObservable(source, delay, scheduler);
	    };
	    SubscribeOnObservable.dispatch = function (arg) {
	        var source = arg.source, subscriber = arg.subscriber;
	        return this.add(source.subscribe(subscriber));
	    };
	    SubscribeOnObservable.prototype._subscribe = function (subscriber) {
	        var delay = this.delayTime;
	        var source = this.source;
	        var scheduler = this.scheduler;
	        return scheduler.schedule(SubscribeOnObservable.dispatch, delay, {
	            source: source, subscriber: subscriber
	        });
	    };
	    return SubscribeOnObservable;
	}(Observable));

	/** PURE_IMPORTS_START _observable_SubscribeOnObservable PURE_IMPORTS_END */
	function subscribeOn(scheduler, delay) {
	    if (delay === void 0) {
	        delay = 0;
	    }
	    return function subscribeOnOperatorFunction(source) {
	        return source.lift(new SubscribeOnOperator(scheduler, delay));
	    };
	}
	var SubscribeOnOperator = /*@__PURE__*/ (function () {
	    function SubscribeOnOperator(scheduler, delay) {
	        this.scheduler = scheduler;
	        this.delay = delay;
	    }
	    SubscribeOnOperator.prototype.call = function (subscriber, source) {
	        return new SubscribeOnObservable(source, this.delay, this.scheduler).subscribe(subscriber);
	    };
	    return SubscribeOnOperator;
	}());

	/** PURE_IMPORTS_START tslib,_map,_observable_from,_innerSubscribe PURE_IMPORTS_END */
	function switchMap(project, resultSelector) {
	    if (typeof resultSelector === 'function') {
	        return function (source) { return source.pipe(switchMap(function (a, i) { return from(project(a, i)).pipe(map(function (b, ii) { return resultSelector(a, b, i, ii); })); })); };
	    }
	    return function (source) { return source.lift(new SwitchMapOperator(project)); };
	}
	var SwitchMapOperator = /*@__PURE__*/ (function () {
	    function SwitchMapOperator(project) {
	        this.project = project;
	    }
	    SwitchMapOperator.prototype.call = function (subscriber, source) {
	        return source.subscribe(new SwitchMapSubscriber(subscriber, this.project));
	    };
	    return SwitchMapOperator;
	}());
	var SwitchMapSubscriber = /*@__PURE__*/ (function (_super) {
	    __extends(SwitchMapSubscriber, _super);
	    function SwitchMapSubscriber(destination, project) {
	        var _this = _super.call(this, destination) || this;
	        _this.project = project;
	        _this.index = 0;
	        return _this;
	    }
	    SwitchMapSubscriber.prototype._next = function (value) {
	        var result;
	        var index = this.index++;
	        try {
	            result = this.project(value, index);
	        }
	        catch (error) {
	            this.destination.error(error);
	            return;
	        }
	        this._innerSub(result);
	    };
	    SwitchMapSubscriber.prototype._innerSub = function (result) {
	        var innerSubscription = this.innerSubscription;
	        if (innerSubscription) {
	            innerSubscription.unsubscribe();
	        }
	        var innerSubscriber = new SimpleInnerSubscriber(this);
	        var destination = this.destination;
	        destination.add(innerSubscriber);
	        this.innerSubscription = innerSubscribe(result, innerSubscriber);
	        if (this.innerSubscription !== innerSubscriber) {
	            destination.add(this.innerSubscription);
	        }
	    };
	    SwitchMapSubscriber.prototype._complete = function () {
	        var innerSubscription = this.innerSubscription;
	        if (!innerSubscription || innerSubscription.closed) {
	            _super.prototype._complete.call(this);
	        }
	        this.unsubscribe();
	    };
	    SwitchMapSubscriber.prototype._unsubscribe = function () {
	        this.innerSubscription = undefined;
	    };
	    SwitchMapSubscriber.prototype.notifyComplete = function () {
	        this.innerSubscription = undefined;
	        if (this.isStopped) {
	            _super.prototype._complete.call(this);
	        }
	    };
	    SwitchMapSubscriber.prototype.notifyNext = function (innerValue) {
	        this.destination.next(innerValue);
	    };
	    return SwitchMapSubscriber;
	}(SimpleOuterSubscriber));

	/** PURE_IMPORTS_START _switchMap,_util_identity PURE_IMPORTS_END */
	function switchAll() {
	    return switchMap(identity);
	}

	/** PURE_IMPORTS_START _switchMap PURE_IMPORTS_END */
	function switchMapTo(innerObservable, resultSelector) {
	    return resultSelector ? switchMap(function () { return innerObservable; }, resultSelector) : switchMap(function () { return innerObservable; });
	}

	/** PURE_IMPORTS_START tslib,_innerSubscribe PURE_IMPORTS_END */
	function takeUntil(notifier) {
	    return function (source) { return source.lift(new TakeUntilOperator(notifier)); };
	}
	var TakeUntilOperator = /*@__PURE__*/ (function () {
	    function TakeUntilOperator(notifier) {
	        this.notifier = notifier;
	    }
	    TakeUntilOperator.prototype.call = function (subscriber, source) {
	        var takeUntilSubscriber = new TakeUntilSubscriber(subscriber);
	        var notifierSubscription = innerSubscribe(this.notifier, new SimpleInnerSubscriber(takeUntilSubscriber));
	        if (notifierSubscription && !takeUntilSubscriber.seenValue) {
	            takeUntilSubscriber.add(notifierSubscription);
	            return source.subscribe(takeUntilSubscriber);
	        }
	        return takeUntilSubscriber;
	    };
	    return TakeUntilOperator;
	}());
	var TakeUntilSubscriber = /*@__PURE__*/ (function (_super) {
	    __extends(TakeUntilSubscriber, _super);
	    function TakeUntilSubscriber(destination) {
	        var _this = _super.call(this, destination) || this;
	        _this.seenValue = false;
	        return _this;
	    }
	    TakeUntilSubscriber.prototype.notifyNext = function () {
	        this.seenValue = true;
	        this.complete();
	    };
	    TakeUntilSubscriber.prototype.notifyComplete = function () {
	    };
	    return TakeUntilSubscriber;
	}(SimpleOuterSubscriber));

	/** PURE_IMPORTS_START tslib,_Subscriber PURE_IMPORTS_END */
	function takeWhile(predicate, inclusive) {
	    if (inclusive === void 0) {
	        inclusive = false;
	    }
	    return function (source) {
	        return source.lift(new TakeWhileOperator(predicate, inclusive));
	    };
	}
	var TakeWhileOperator = /*@__PURE__*/ (function () {
	    function TakeWhileOperator(predicate, inclusive) {
	        this.predicate = predicate;
	        this.inclusive = inclusive;
	    }
	    TakeWhileOperator.prototype.call = function (subscriber, source) {
	        return source.subscribe(new TakeWhileSubscriber(subscriber, this.predicate, this.inclusive));
	    };
	    return TakeWhileOperator;
	}());
	var TakeWhileSubscriber = /*@__PURE__*/ (function (_super) {
	    __extends(TakeWhileSubscriber, _super);
	    function TakeWhileSubscriber(destination, predicate, inclusive) {
	        var _this = _super.call(this, destination) || this;
	        _this.predicate = predicate;
	        _this.inclusive = inclusive;
	        _this.index = 0;
	        return _this;
	    }
	    TakeWhileSubscriber.prototype._next = function (value) {
	        var destination = this.destination;
	        var result;
	        try {
	            result = this.predicate(value, this.index++);
	        }
	        catch (err) {
	            destination.error(err);
	            return;
	        }
	        this.nextOrComplete(value, result);
	    };
	    TakeWhileSubscriber.prototype.nextOrComplete = function (value, predicateResult) {
	        var destination = this.destination;
	        if (Boolean(predicateResult)) {
	            destination.next(value);
	        }
	        else {
	            if (this.inclusive) {
	                destination.next(value);
	            }
	            destination.complete();
	        }
	    };
	    return TakeWhileSubscriber;
	}(Subscriber));

	/** PURE_IMPORTS_START  PURE_IMPORTS_END */
	function noop() { }

	/** PURE_IMPORTS_START tslib,_Subscriber,_util_noop,_util_isFunction PURE_IMPORTS_END */
	function tap(nextOrObserver, error, complete) {
	    return function tapOperatorFunction(source) {
	        return source.lift(new DoOperator(nextOrObserver, error, complete));
	    };
	}
	var DoOperator = /*@__PURE__*/ (function () {
	    function DoOperator(nextOrObserver, error, complete) {
	        this.nextOrObserver = nextOrObserver;
	        this.error = error;
	        this.complete = complete;
	    }
	    DoOperator.prototype.call = function (subscriber, source) {
	        return source.subscribe(new TapSubscriber(subscriber, this.nextOrObserver, this.error, this.complete));
	    };
	    return DoOperator;
	}());
	var TapSubscriber = /*@__PURE__*/ (function (_super) {
	    __extends(TapSubscriber, _super);
	    function TapSubscriber(destination, observerOrNext, error, complete) {
	        var _this = _super.call(this, destination) || this;
	        _this._tapNext = noop;
	        _this._tapError = noop;
	        _this._tapComplete = noop;
	        _this._tapError = error || noop;
	        _this._tapComplete = complete || noop;
	        if (isFunction(observerOrNext)) {
	            _this._context = _this;
	            _this._tapNext = observerOrNext;
	        }
	        else if (observerOrNext) {
	            _this._context = observerOrNext;
	            _this._tapNext = observerOrNext.next || noop;
	            _this._tapError = observerOrNext.error || noop;
	            _this._tapComplete = observerOrNext.complete || noop;
	        }
	        return _this;
	    }
	    TapSubscriber.prototype._next = function (value) {
	        try {
	            this._tapNext.call(this._context, value);
	        }
	        catch (err) {
	            this.destination.error(err);
	            return;
	        }
	        this.destination.next(value);
	    };
	    TapSubscriber.prototype._error = function (err) {
	        try {
	            this._tapError.call(this._context, err);
	        }
	        catch (err) {
	            this.destination.error(err);
	            return;
	        }
	        this.destination.error(err);
	    };
	    TapSubscriber.prototype._complete = function () {
	        try {
	            this._tapComplete.call(this._context);
	        }
	        catch (err) {
	            this.destination.error(err);
	            return;
	        }
	        return this.destination.complete();
	    };
	    return TapSubscriber;
	}(Subscriber));

	/** PURE_IMPORTS_START tslib,_innerSubscribe PURE_IMPORTS_END */
	var defaultThrottleConfig = {
	    leading: true,
	    trailing: false
	};
	function throttle(durationSelector, config) {
	    if (config === void 0) {
	        config = defaultThrottleConfig;
	    }
	    return function (source) { return source.lift(new ThrottleOperator(durationSelector, !!config.leading, !!config.trailing)); };
	}
	var ThrottleOperator = /*@__PURE__*/ (function () {
	    function ThrottleOperator(durationSelector, leading, trailing) {
	        this.durationSelector = durationSelector;
	        this.leading = leading;
	        this.trailing = trailing;
	    }
	    ThrottleOperator.prototype.call = function (subscriber, source) {
	        return source.subscribe(new ThrottleSubscriber(subscriber, this.durationSelector, this.leading, this.trailing));
	    };
	    return ThrottleOperator;
	}());
	var ThrottleSubscriber = /*@__PURE__*/ (function (_super) {
	    __extends(ThrottleSubscriber, _super);
	    function ThrottleSubscriber(destination, durationSelector, _leading, _trailing) {
	        var _this = _super.call(this, destination) || this;
	        _this.destination = destination;
	        _this.durationSelector = durationSelector;
	        _this._leading = _leading;
	        _this._trailing = _trailing;
	        _this._hasValue = false;
	        return _this;
	    }
	    ThrottleSubscriber.prototype._next = function (value) {
	        this._hasValue = true;
	        this._sendValue = value;
	        if (!this._throttled) {
	            if (this._leading) {
	                this.send();
	            }
	            else {
	                this.throttle(value);
	            }
	        }
	    };
	    ThrottleSubscriber.prototype.send = function () {
	        var _a = this, _hasValue = _a._hasValue, _sendValue = _a._sendValue;
	        if (_hasValue) {
	            this.destination.next(_sendValue);
	            this.throttle(_sendValue);
	        }
	        this._hasValue = false;
	        this._sendValue = undefined;
	    };
	    ThrottleSubscriber.prototype.throttle = function (value) {
	        var duration = this.tryDurationSelector(value);
	        if (!!duration) {
	            this.add(this._throttled = innerSubscribe(duration, new SimpleInnerSubscriber(this)));
	        }
	    };
	    ThrottleSubscriber.prototype.tryDurationSelector = function (value) {
	        try {
	            return this.durationSelector(value);
	        }
	        catch (err) {
	            this.destination.error(err);
	            return null;
	        }
	    };
	    ThrottleSubscriber.prototype.throttlingDone = function () {
	        var _a = this, _throttled = _a._throttled, _trailing = _a._trailing;
	        if (_throttled) {
	            _throttled.unsubscribe();
	        }
	        this._throttled = undefined;
	        if (_trailing) {
	            this.send();
	        }
	    };
	    ThrottleSubscriber.prototype.notifyNext = function () {
	        this.throttlingDone();
	    };
	    ThrottleSubscriber.prototype.notifyComplete = function () {
	        this.throttlingDone();
	    };
	    return ThrottleSubscriber;
	}(SimpleOuterSubscriber));

	/** PURE_IMPORTS_START tslib,_Subscriber,_scheduler_async,_throttle PURE_IMPORTS_END */
	function throttleTime(duration, scheduler, config) {
	    if (scheduler === void 0) {
	        scheduler = async;
	    }
	    if (config === void 0) {
	        config = defaultThrottleConfig;
	    }
	    return function (source) { return source.lift(new ThrottleTimeOperator(duration, scheduler, config.leading, config.trailing)); };
	}
	var ThrottleTimeOperator = /*@__PURE__*/ (function () {
	    function ThrottleTimeOperator(duration, scheduler, leading, trailing) {
	        this.duration = duration;
	        this.scheduler = scheduler;
	        this.leading = leading;
	        this.trailing = trailing;
	    }
	    ThrottleTimeOperator.prototype.call = function (subscriber, source) {
	        return source.subscribe(new ThrottleTimeSubscriber(subscriber, this.duration, this.scheduler, this.leading, this.trailing));
	    };
	    return ThrottleTimeOperator;
	}());
	var ThrottleTimeSubscriber = /*@__PURE__*/ (function (_super) {
	    __extends(ThrottleTimeSubscriber, _super);
	    function ThrottleTimeSubscriber(destination, duration, scheduler, leading, trailing) {
	        var _this = _super.call(this, destination) || this;
	        _this.duration = duration;
	        _this.scheduler = scheduler;
	        _this.leading = leading;
	        _this.trailing = trailing;
	        _this._hasTrailingValue = false;
	        _this._trailingValue = null;
	        return _this;
	    }
	    ThrottleTimeSubscriber.prototype._next = function (value) {
	        if (this.throttled) {
	            if (this.trailing) {
	                this._trailingValue = value;
	                this._hasTrailingValue = true;
	            }
	        }
	        else {
	            this.add(this.throttled = this.scheduler.schedule(dispatchNext, this.duration, { subscriber: this }));
	            if (this.leading) {
	                this.destination.next(value);
	            }
	            else if (this.trailing) {
	                this._trailingValue = value;
	                this._hasTrailingValue = true;
	            }
	        }
	    };
	    ThrottleTimeSubscriber.prototype._complete = function () {
	        if (this._hasTrailingValue) {
	            this.destination.next(this._trailingValue);
	            this.destination.complete();
	        }
	        else {
	            this.destination.complete();
	        }
	    };
	    ThrottleTimeSubscriber.prototype.clearThrottle = function () {
	        var throttled = this.throttled;
	        if (throttled) {
	            if (this.trailing && this._hasTrailingValue) {
	                this.destination.next(this._trailingValue);
	                this._trailingValue = null;
	                this._hasTrailingValue = false;
	            }
	            throttled.unsubscribe();
	            this.remove(throttled);
	            this.throttled = null;
	        }
	    };
	    return ThrottleTimeSubscriber;
	}(Subscriber));
	function dispatchNext(arg) {
	    var subscriber = arg.subscriber;
	    subscriber.clearThrottle();
	}

	/** PURE_IMPORTS_START _Observable,_from,_empty PURE_IMPORTS_END */
	function defer(observableFactory) {
	    return new Observable(function (subscriber) {
	        var input;
	        try {
	            input = observableFactory();
	        }
	        catch (err) {
	            subscriber.error(err);
	            return undefined;
	        }
	        var source = input ? from(input) : empty();
	        return source.subscribe(subscriber);
	    });
	}

	/** PURE_IMPORTS_START _scheduler_async,_scan,_observable_defer,_map PURE_IMPORTS_END */
	function timeInterval(scheduler) {
	    if (scheduler === void 0) {
	        scheduler = async;
	    }
	    return function (source) {
	        return defer(function () {
	            return source.pipe(scan(function (_a, value) {
	                var current = _a.current;
	                return ({ value: value, current: scheduler.now(), last: current });
	            }, { current: scheduler.now(), value: undefined, last: undefined }), map(function (_a) {
	                var current = _a.current, last = _a.last, value = _a.value;
	                return new TimeInterval(value, current - last);
	            }));
	        });
	    };
	}
	var TimeInterval = /*@__PURE__*/ (function () {
	    function TimeInterval(value, interval) {
	        this.value = value;
	        this.interval = interval;
	    }
	    return TimeInterval;
	}());

	/** PURE_IMPORTS_START  PURE_IMPORTS_END */
	var TimeoutErrorImpl = /*@__PURE__*/ (function () {
	    function TimeoutErrorImpl() {
	        Error.call(this);
	        this.message = 'Timeout has occurred';
	        this.name = 'TimeoutError';
	        return this;
	    }
	    TimeoutErrorImpl.prototype = /*@__PURE__*/ Object.create(Error.prototype);
	    return TimeoutErrorImpl;
	})();
	var TimeoutError = TimeoutErrorImpl;

	/** PURE_IMPORTS_START tslib,_scheduler_async,_util_isDate,_innerSubscribe PURE_IMPORTS_END */
	function timeoutWith(due, withObservable, scheduler) {
	    if (scheduler === void 0) {
	        scheduler = async;
	    }
	    return function (source) {
	        var absoluteTimeout = isDate(due);
	        var waitFor = absoluteTimeout ? (+due - scheduler.now()) : Math.abs(due);
	        return source.lift(new TimeoutWithOperator(waitFor, absoluteTimeout, withObservable, scheduler));
	    };
	}
	var TimeoutWithOperator = /*@__PURE__*/ (function () {
	    function TimeoutWithOperator(waitFor, absoluteTimeout, withObservable, scheduler) {
	        this.waitFor = waitFor;
	        this.absoluteTimeout = absoluteTimeout;
	        this.withObservable = withObservable;
	        this.scheduler = scheduler;
	    }
	    TimeoutWithOperator.prototype.call = function (subscriber, source) {
	        return source.subscribe(new TimeoutWithSubscriber(subscriber, this.absoluteTimeout, this.waitFor, this.withObservable, this.scheduler));
	    };
	    return TimeoutWithOperator;
	}());
	var TimeoutWithSubscriber = /*@__PURE__*/ (function (_super) {
	    __extends(TimeoutWithSubscriber, _super);
	    function TimeoutWithSubscriber(destination, absoluteTimeout, waitFor, withObservable, scheduler) {
	        var _this = _super.call(this, destination) || this;
	        _this.absoluteTimeout = absoluteTimeout;
	        _this.waitFor = waitFor;
	        _this.withObservable = withObservable;
	        _this.scheduler = scheduler;
	        _this.scheduleTimeout();
	        return _this;
	    }
	    TimeoutWithSubscriber.dispatchTimeout = function (subscriber) {
	        var withObservable = subscriber.withObservable;
	        subscriber._unsubscribeAndRecycle();
	        subscriber.add(innerSubscribe(withObservable, new SimpleInnerSubscriber(subscriber)));
	    };
	    TimeoutWithSubscriber.prototype.scheduleTimeout = function () {
	        var action = this.action;
	        if (action) {
	            this.action = action.schedule(this, this.waitFor);
	        }
	        else {
	            this.add(this.action = this.scheduler.schedule(TimeoutWithSubscriber.dispatchTimeout, this.waitFor, this));
	        }
	    };
	    TimeoutWithSubscriber.prototype._next = function (value) {
	        if (!this.absoluteTimeout) {
	            this.scheduleTimeout();
	        }
	        _super.prototype._next.call(this, value);
	    };
	    TimeoutWithSubscriber.prototype._unsubscribe = function () {
	        this.action = undefined;
	        this.scheduler = null;
	        this.withObservable = null;
	    };
	    return TimeoutWithSubscriber;
	}(SimpleOuterSubscriber));

	/** PURE_IMPORTS_START _scheduler_async,_util_TimeoutError,_timeoutWith,_observable_throwError PURE_IMPORTS_END */
	function timeout(due, scheduler) {
	    if (scheduler === void 0) {
	        scheduler = async;
	    }
	    return timeoutWith(due, throwError(new TimeoutError()), scheduler);
	}

	/** PURE_IMPORTS_START _scheduler_async,_map PURE_IMPORTS_END */
	function timestamp(scheduler) {
	    if (scheduler === void 0) {
	        scheduler = async;
	    }
	    return map(function (value) { return new Timestamp(value, scheduler.now()); });
	}
	var Timestamp = /*@__PURE__*/ (function () {
	    function Timestamp(value, timestamp) {
	        this.value = value;
	        this.timestamp = timestamp;
	    }
	    return Timestamp;
	}());

	/** PURE_IMPORTS_START _reduce PURE_IMPORTS_END */
	function toArrayReducer(arr, item, index) {
	    if (index === 0) {
	        return [item];
	    }
	    arr.push(item);
	    return arr;
	}
	function toArray() {
	    return reduce(toArrayReducer, []);
	}

	/** PURE_IMPORTS_START tslib,_Subject,_innerSubscribe PURE_IMPORTS_END */
	function window$1(windowBoundaries) {
	    return function windowOperatorFunction(source) {
	        return source.lift(new WindowOperator$1(windowBoundaries));
	    };
	}
	var WindowOperator$1 = /*@__PURE__*/ (function () {
	    function WindowOperator(windowBoundaries) {
	        this.windowBoundaries = windowBoundaries;
	    }
	    WindowOperator.prototype.call = function (subscriber, source) {
	        var windowSubscriber = new WindowSubscriber$1(subscriber);
	        var sourceSubscription = source.subscribe(windowSubscriber);
	        if (!sourceSubscription.closed) {
	            windowSubscriber.add(innerSubscribe(this.windowBoundaries, new SimpleInnerSubscriber(windowSubscriber)));
	        }
	        return sourceSubscription;
	    };
	    return WindowOperator;
	}());
	var WindowSubscriber$1 = /*@__PURE__*/ (function (_super) {
	    __extends(WindowSubscriber, _super);
	    function WindowSubscriber(destination) {
	        var _this = _super.call(this, destination) || this;
	        _this.window = new Subject();
	        destination.next(_this.window);
	        return _this;
	    }
	    WindowSubscriber.prototype.notifyNext = function () {
	        this.openWindow();
	    };
	    WindowSubscriber.prototype.notifyError = function (error) {
	        this._error(error);
	    };
	    WindowSubscriber.prototype.notifyComplete = function () {
	        this._complete();
	    };
	    WindowSubscriber.prototype._next = function (value) {
	        this.window.next(value);
	    };
	    WindowSubscriber.prototype._error = function (err) {
	        this.window.error(err);
	        this.destination.error(err);
	    };
	    WindowSubscriber.prototype._complete = function () {
	        this.window.complete();
	        this.destination.complete();
	    };
	    WindowSubscriber.prototype._unsubscribe = function () {
	        this.window = null;
	    };
	    WindowSubscriber.prototype.openWindow = function () {
	        var prevWindow = this.window;
	        if (prevWindow) {
	            prevWindow.complete();
	        }
	        var destination = this.destination;
	        var newWindow = this.window = new Subject();
	        destination.next(newWindow);
	    };
	    return WindowSubscriber;
	}(SimpleOuterSubscriber));

	/** PURE_IMPORTS_START tslib,_Subscriber,_Subject PURE_IMPORTS_END */
	function windowCount(windowSize, startWindowEvery) {
	    if (startWindowEvery === void 0) {
	        startWindowEvery = 0;
	    }
	    return function windowCountOperatorFunction(source) {
	        return source.lift(new WindowCountOperator(windowSize, startWindowEvery));
	    };
	}
	var WindowCountOperator = /*@__PURE__*/ (function () {
	    function WindowCountOperator(windowSize, startWindowEvery) {
	        this.windowSize = windowSize;
	        this.startWindowEvery = startWindowEvery;
	    }
	    WindowCountOperator.prototype.call = function (subscriber, source) {
	        return source.subscribe(new WindowCountSubscriber(subscriber, this.windowSize, this.startWindowEvery));
	    };
	    return WindowCountOperator;
	}());
	var WindowCountSubscriber = /*@__PURE__*/ (function (_super) {
	    __extends(WindowCountSubscriber, _super);
	    function WindowCountSubscriber(destination, windowSize, startWindowEvery) {
	        var _this = _super.call(this, destination) || this;
	        _this.destination = destination;
	        _this.windowSize = windowSize;
	        _this.startWindowEvery = startWindowEvery;
	        _this.windows = [new Subject()];
	        _this.count = 0;
	        destination.next(_this.windows[0]);
	        return _this;
	    }
	    WindowCountSubscriber.prototype._next = function (value) {
	        var startWindowEvery = (this.startWindowEvery > 0) ? this.startWindowEvery : this.windowSize;
	        var destination = this.destination;
	        var windowSize = this.windowSize;
	        var windows = this.windows;
	        var len = windows.length;
	        for (var i = 0; i < len && !this.closed; i++) {
	            windows[i].next(value);
	        }
	        var c = this.count - windowSize + 1;
	        if (c >= 0 && c % startWindowEvery === 0 && !this.closed) {
	            windows.shift().complete();
	        }
	        if (++this.count % startWindowEvery === 0 && !this.closed) {
	            var window_1 = new Subject();
	            windows.push(window_1);
	            destination.next(window_1);
	        }
	    };
	    WindowCountSubscriber.prototype._error = function (err) {
	        var windows = this.windows;
	        if (windows) {
	            while (windows.length > 0 && !this.closed) {
	                windows.shift().error(err);
	            }
	        }
	        this.destination.error(err);
	    };
	    WindowCountSubscriber.prototype._complete = function () {
	        var windows = this.windows;
	        if (windows) {
	            while (windows.length > 0 && !this.closed) {
	                windows.shift().complete();
	            }
	        }
	        this.destination.complete();
	    };
	    WindowCountSubscriber.prototype._unsubscribe = function () {
	        this.count = 0;
	        this.windows = null;
	    };
	    return WindowCountSubscriber;
	}(Subscriber));

	/** PURE_IMPORTS_START tslib,_Subject,_scheduler_async,_Subscriber,_util_isNumeric,_util_isScheduler PURE_IMPORTS_END */
	function windowTime(windowTimeSpan) {
	    var scheduler = async;
	    var windowCreationInterval = null;
	    var maxWindowSize = Number.POSITIVE_INFINITY;
	    if (isScheduler(arguments[3])) {
	        scheduler = arguments[3];
	    }
	    if (isScheduler(arguments[2])) {
	        scheduler = arguments[2];
	    }
	    else if (isNumeric(arguments[2])) {
	        maxWindowSize = Number(arguments[2]);
	    }
	    if (isScheduler(arguments[1])) {
	        scheduler = arguments[1];
	    }
	    else if (isNumeric(arguments[1])) {
	        windowCreationInterval = Number(arguments[1]);
	    }
	    return function windowTimeOperatorFunction(source) {
	        return source.lift(new WindowTimeOperator(windowTimeSpan, windowCreationInterval, maxWindowSize, scheduler));
	    };
	}
	var WindowTimeOperator = /*@__PURE__*/ (function () {
	    function WindowTimeOperator(windowTimeSpan, windowCreationInterval, maxWindowSize, scheduler) {
	        this.windowTimeSpan = windowTimeSpan;
	        this.windowCreationInterval = windowCreationInterval;
	        this.maxWindowSize = maxWindowSize;
	        this.scheduler = scheduler;
	    }
	    WindowTimeOperator.prototype.call = function (subscriber, source) {
	        return source.subscribe(new WindowTimeSubscriber(subscriber, this.windowTimeSpan, this.windowCreationInterval, this.maxWindowSize, this.scheduler));
	    };
	    return WindowTimeOperator;
	}());
	var CountedSubject = /*@__PURE__*/ (function (_super) {
	    __extends(CountedSubject, _super);
	    function CountedSubject() {
	        var _this = _super !== null && _super.apply(this, arguments) || this;
	        _this._numberOfNextedValues = 0;
	        return _this;
	    }
	    CountedSubject.prototype.next = function (value) {
	        this._numberOfNextedValues++;
	        _super.prototype.next.call(this, value);
	    };
	    Object.defineProperty(CountedSubject.prototype, "numberOfNextedValues", {
	        get: function () {
	            return this._numberOfNextedValues;
	        },
	        enumerable: true,
	        configurable: true
	    });
	    return CountedSubject;
	}(Subject));
	var WindowTimeSubscriber = /*@__PURE__*/ (function (_super) {
	    __extends(WindowTimeSubscriber, _super);
	    function WindowTimeSubscriber(destination, windowTimeSpan, windowCreationInterval, maxWindowSize, scheduler) {
	        var _this = _super.call(this, destination) || this;
	        _this.destination = destination;
	        _this.windowTimeSpan = windowTimeSpan;
	        _this.windowCreationInterval = windowCreationInterval;
	        _this.maxWindowSize = maxWindowSize;
	        _this.scheduler = scheduler;
	        _this.windows = [];
	        var window = _this.openWindow();
	        if (windowCreationInterval !== null && windowCreationInterval >= 0) {
	            var closeState = { subscriber: _this, window: window, context: null };
	            var creationState = { windowTimeSpan: windowTimeSpan, windowCreationInterval: windowCreationInterval, subscriber: _this, scheduler: scheduler };
	            _this.add(scheduler.schedule(dispatchWindowClose, windowTimeSpan, closeState));
	            _this.add(scheduler.schedule(dispatchWindowCreation, windowCreationInterval, creationState));
	        }
	        else {
	            var timeSpanOnlyState = { subscriber: _this, window: window, windowTimeSpan: windowTimeSpan };
	            _this.add(scheduler.schedule(dispatchWindowTimeSpanOnly, windowTimeSpan, timeSpanOnlyState));
	        }
	        return _this;
	    }
	    WindowTimeSubscriber.prototype._next = function (value) {
	        var windows = this.windows;
	        var len = windows.length;
	        for (var i = 0; i < len; i++) {
	            var window_1 = windows[i];
	            if (!window_1.closed) {
	                window_1.next(value);
	                if (window_1.numberOfNextedValues >= this.maxWindowSize) {
	                    this.closeWindow(window_1);
	                }
	            }
	        }
	    };
	    WindowTimeSubscriber.prototype._error = function (err) {
	        var windows = this.windows;
	        while (windows.length > 0) {
	            windows.shift().error(err);
	        }
	        this.destination.error(err);
	    };
	    WindowTimeSubscriber.prototype._complete = function () {
	        var windows = this.windows;
	        while (windows.length > 0) {
	            var window_2 = windows.shift();
	            if (!window_2.closed) {
	                window_2.complete();
	            }
	        }
	        this.destination.complete();
	    };
	    WindowTimeSubscriber.prototype.openWindow = function () {
	        var window = new CountedSubject();
	        this.windows.push(window);
	        var destination = this.destination;
	        destination.next(window);
	        return window;
	    };
	    WindowTimeSubscriber.prototype.closeWindow = function (window) {
	        window.complete();
	        var windows = this.windows;
	        windows.splice(windows.indexOf(window), 1);
	    };
	    return WindowTimeSubscriber;
	}(Subscriber));
	function dispatchWindowTimeSpanOnly(state) {
	    var subscriber = state.subscriber, windowTimeSpan = state.windowTimeSpan, window = state.window;
	    if (window) {
	        subscriber.closeWindow(window);
	    }
	    state.window = subscriber.openWindow();
	    this.schedule(state, windowTimeSpan);
	}
	function dispatchWindowCreation(state) {
	    var windowTimeSpan = state.windowTimeSpan, subscriber = state.subscriber, scheduler = state.scheduler, windowCreationInterval = state.windowCreationInterval;
	    var window = subscriber.openWindow();
	    var action = this;
	    var context = { action: action, subscription: null };
	    var timeSpanState = { subscriber: subscriber, window: window, context: context };
	    context.subscription = scheduler.schedule(dispatchWindowClose, windowTimeSpan, timeSpanState);
	    action.add(context.subscription);
	    action.schedule(state, windowCreationInterval);
	}
	function dispatchWindowClose(state) {
	    var subscriber = state.subscriber, window = state.window, context = state.context;
	    if (context && context.action && context.subscription) {
	        context.action.remove(context.subscription);
	    }
	    subscriber.closeWindow(window);
	}

	/** PURE_IMPORTS_START tslib,_Subject,_Subscription,_OuterSubscriber,_util_subscribeToResult PURE_IMPORTS_END */
	function windowToggle(openings, closingSelector) {
	    return function (source) { return source.lift(new WindowToggleOperator(openings, closingSelector)); };
	}
	var WindowToggleOperator = /*@__PURE__*/ (function () {
	    function WindowToggleOperator(openings, closingSelector) {
	        this.openings = openings;
	        this.closingSelector = closingSelector;
	    }
	    WindowToggleOperator.prototype.call = function (subscriber, source) {
	        return source.subscribe(new WindowToggleSubscriber(subscriber, this.openings, this.closingSelector));
	    };
	    return WindowToggleOperator;
	}());
	var WindowToggleSubscriber = /*@__PURE__*/ (function (_super) {
	    __extends(WindowToggleSubscriber, _super);
	    function WindowToggleSubscriber(destination, openings, closingSelector) {
	        var _this = _super.call(this, destination) || this;
	        _this.openings = openings;
	        _this.closingSelector = closingSelector;
	        _this.contexts = [];
	        _this.add(_this.openSubscription = subscribeToResult(_this, openings, openings));
	        return _this;
	    }
	    WindowToggleSubscriber.prototype._next = function (value) {
	        var contexts = this.contexts;
	        if (contexts) {
	            var len = contexts.length;
	            for (var i = 0; i < len; i++) {
	                contexts[i].window.next(value);
	            }
	        }
	    };
	    WindowToggleSubscriber.prototype._error = function (err) {
	        var contexts = this.contexts;
	        this.contexts = null;
	        if (contexts) {
	            var len = contexts.length;
	            var index = -1;
	            while (++index < len) {
	                var context_1 = contexts[index];
	                context_1.window.error(err);
	                context_1.subscription.unsubscribe();
	            }
	        }
	        _super.prototype._error.call(this, err);
	    };
	    WindowToggleSubscriber.prototype._complete = function () {
	        var contexts = this.contexts;
	        this.contexts = null;
	        if (contexts) {
	            var len = contexts.length;
	            var index = -1;
	            while (++index < len) {
	                var context_2 = contexts[index];
	                context_2.window.complete();
	                context_2.subscription.unsubscribe();
	            }
	        }
	        _super.prototype._complete.call(this);
	    };
	    WindowToggleSubscriber.prototype._unsubscribe = function () {
	        var contexts = this.contexts;
	        this.contexts = null;
	        if (contexts) {
	            var len = contexts.length;
	            var index = -1;
	            while (++index < len) {
	                var context_3 = contexts[index];
	                context_3.window.unsubscribe();
	                context_3.subscription.unsubscribe();
	            }
	        }
	    };
	    WindowToggleSubscriber.prototype.notifyNext = function (outerValue, innerValue, outerIndex, innerIndex, innerSub) {
	        if (outerValue === this.openings) {
	            var closingNotifier = void 0;
	            try {
	                var closingSelector = this.closingSelector;
	                closingNotifier = closingSelector(innerValue);
	            }
	            catch (e) {
	                return this.error(e);
	            }
	            var window_1 = new Subject();
	            var subscription = new Subscription();
	            var context_4 = { window: window_1, subscription: subscription };
	            this.contexts.push(context_4);
	            var innerSubscription = subscribeToResult(this, closingNotifier, context_4);
	            if (innerSubscription.closed) {
	                this.closeWindow(this.contexts.length - 1);
	            }
	            else {
	                innerSubscription.context = context_4;
	                subscription.add(innerSubscription);
	            }
	            this.destination.next(window_1);
	        }
	        else {
	            this.closeWindow(this.contexts.indexOf(outerValue));
	        }
	    };
	    WindowToggleSubscriber.prototype.notifyError = function (err) {
	        this.error(err);
	    };
	    WindowToggleSubscriber.prototype.notifyComplete = function (inner) {
	        if (inner !== this.openSubscription) {
	            this.closeWindow(this.contexts.indexOf(inner.context));
	        }
	    };
	    WindowToggleSubscriber.prototype.closeWindow = function (index) {
	        if (index === -1) {
	            return;
	        }
	        var contexts = this.contexts;
	        var context = contexts[index];
	        var window = context.window, subscription = context.subscription;
	        contexts.splice(index, 1);
	        window.complete();
	        subscription.unsubscribe();
	    };
	    return WindowToggleSubscriber;
	}(OuterSubscriber));

	/** PURE_IMPORTS_START tslib,_Subject,_OuterSubscriber,_util_subscribeToResult PURE_IMPORTS_END */
	function windowWhen(closingSelector) {
	    return function windowWhenOperatorFunction(source) {
	        return source.lift(new WindowOperator(closingSelector));
	    };
	}
	var WindowOperator = /*@__PURE__*/ (function () {
	    function WindowOperator(closingSelector) {
	        this.closingSelector = closingSelector;
	    }
	    WindowOperator.prototype.call = function (subscriber, source) {
	        return source.subscribe(new WindowSubscriber(subscriber, this.closingSelector));
	    };
	    return WindowOperator;
	}());
	var WindowSubscriber = /*@__PURE__*/ (function (_super) {
	    __extends(WindowSubscriber, _super);
	    function WindowSubscriber(destination, closingSelector) {
	        var _this = _super.call(this, destination) || this;
	        _this.destination = destination;
	        _this.closingSelector = closingSelector;
	        _this.openWindow();
	        return _this;
	    }
	    WindowSubscriber.prototype.notifyNext = function (_outerValue, _innerValue, _outerIndex, _innerIndex, innerSub) {
	        this.openWindow(innerSub);
	    };
	    WindowSubscriber.prototype.notifyError = function (error) {
	        this._error(error);
	    };
	    WindowSubscriber.prototype.notifyComplete = function (innerSub) {
	        this.openWindow(innerSub);
	    };
	    WindowSubscriber.prototype._next = function (value) {
	        this.window.next(value);
	    };
	    WindowSubscriber.prototype._error = function (err) {
	        this.window.error(err);
	        this.destination.error(err);
	        this.unsubscribeClosingNotification();
	    };
	    WindowSubscriber.prototype._complete = function () {
	        this.window.complete();
	        this.destination.complete();
	        this.unsubscribeClosingNotification();
	    };
	    WindowSubscriber.prototype.unsubscribeClosingNotification = function () {
	        if (this.closingNotification) {
	            this.closingNotification.unsubscribe();
	        }
	    };
	    WindowSubscriber.prototype.openWindow = function (innerSub) {
	        if (innerSub === void 0) {
	            innerSub = null;
	        }
	        if (innerSub) {
	            this.remove(innerSub);
	            innerSub.unsubscribe();
	        }
	        var prevWindow = this.window;
	        if (prevWindow) {
	            prevWindow.complete();
	        }
	        var window = this.window = new Subject();
	        this.destination.next(window);
	        var closingNotifier;
	        try {
	            var closingSelector = this.closingSelector;
	            closingNotifier = closingSelector();
	        }
	        catch (e) {
	            this.destination.error(e);
	            this.window.error(e);
	            return;
	        }
	        this.add(this.closingNotification = subscribeToResult(this, closingNotifier));
	    };
	    return WindowSubscriber;
	}(OuterSubscriber));

	/** PURE_IMPORTS_START tslib,_OuterSubscriber,_util_subscribeToResult PURE_IMPORTS_END */
	function withLatestFrom() {
	    var args = [];
	    for (var _i = 0; _i < arguments.length; _i++) {
	        args[_i] = arguments[_i];
	    }
	    return function (source) {
	        var project;
	        if (typeof args[args.length - 1] === 'function') {
	            project = args.pop();
	        }
	        var observables = args;
	        return source.lift(new WithLatestFromOperator(observables, project));
	    };
	}
	var WithLatestFromOperator = /*@__PURE__*/ (function () {
	    function WithLatestFromOperator(observables, project) {
	        this.observables = observables;
	        this.project = project;
	    }
	    WithLatestFromOperator.prototype.call = function (subscriber, source) {
	        return source.subscribe(new WithLatestFromSubscriber(subscriber, this.observables, this.project));
	    };
	    return WithLatestFromOperator;
	}());
	var WithLatestFromSubscriber = /*@__PURE__*/ (function (_super) {
	    __extends(WithLatestFromSubscriber, _super);
	    function WithLatestFromSubscriber(destination, observables, project) {
	        var _this = _super.call(this, destination) || this;
	        _this.observables = observables;
	        _this.project = project;
	        _this.toRespond = [];
	        var len = observables.length;
	        _this.values = new Array(len);
	        for (var i = 0; i < len; i++) {
	            _this.toRespond.push(i);
	        }
	        for (var i = 0; i < len; i++) {
	            var observable = observables[i];
	            _this.add(subscribeToResult(_this, observable, undefined, i));
	        }
	        return _this;
	    }
	    WithLatestFromSubscriber.prototype.notifyNext = function (_outerValue, innerValue, outerIndex) {
	        this.values[outerIndex] = innerValue;
	        var toRespond = this.toRespond;
	        if (toRespond.length > 0) {
	            var found = toRespond.indexOf(outerIndex);
	            if (found !== -1) {
	                toRespond.splice(found, 1);
	            }
	        }
	    };
	    WithLatestFromSubscriber.prototype.notifyComplete = function () {
	    };
	    WithLatestFromSubscriber.prototype._next = function (value) {
	        if (this.toRespond.length === 0) {
	            var args = [value].concat(this.values);
	            if (this.project) {
	                this._tryProject(args);
	            }
	            else {
	                this.destination.next(args);
	            }
	        }
	    };
	    WithLatestFromSubscriber.prototype._tryProject = function (args) {
	        var result;
	        try {
	            result = this.project.apply(this, args);
	        }
	        catch (err) {
	            this.destination.error(err);
	            return;
	        }
	        this.destination.next(result);
	    };
	    return WithLatestFromSubscriber;
	}(OuterSubscriber));

	/** PURE_IMPORTS_START tslib,_fromArray,_util_isArray,_Subscriber,_.._internal_symbol_iterator,_innerSubscribe PURE_IMPORTS_END */
	function zip$1() {
	    var observables = [];
	    for (var _i = 0; _i < arguments.length; _i++) {
	        observables[_i] = arguments[_i];
	    }
	    var resultSelector = observables[observables.length - 1];
	    if (typeof resultSelector === 'function') {
	        observables.pop();
	    }
	    return fromArray(observables, undefined).lift(new ZipOperator(resultSelector));
	}
	var ZipOperator = /*@__PURE__*/ (function () {
	    function ZipOperator(resultSelector) {
	        this.resultSelector = resultSelector;
	    }
	    ZipOperator.prototype.call = function (subscriber, source) {
	        return source.subscribe(new ZipSubscriber(subscriber, this.resultSelector));
	    };
	    return ZipOperator;
	}());
	var ZipSubscriber = /*@__PURE__*/ (function (_super) {
	    __extends(ZipSubscriber, _super);
	    function ZipSubscriber(destination, resultSelector, values) {
	        var _this = _super.call(this, destination) || this;
	        _this.resultSelector = resultSelector;
	        _this.iterators = [];
	        _this.active = 0;
	        _this.resultSelector = (typeof resultSelector === 'function') ? resultSelector : undefined;
	        return _this;
	    }
	    ZipSubscriber.prototype._next = function (value) {
	        var iterators = this.iterators;
	        if (isArray(value)) {
	            iterators.push(new StaticArrayIterator(value));
	        }
	        else if (typeof value[iterator] === 'function') {
	            iterators.push(new StaticIterator(value[iterator]()));
	        }
	        else {
	            iterators.push(new ZipBufferIterator(this.destination, this, value));
	        }
	    };
	    ZipSubscriber.prototype._complete = function () {
	        var iterators = this.iterators;
	        var len = iterators.length;
	        this.unsubscribe();
	        if (len === 0) {
	            this.destination.complete();
	            return;
	        }
	        this.active = len;
	        for (var i = 0; i < len; i++) {
	            var iterator = iterators[i];
	            if (iterator.stillUnsubscribed) {
	                var destination = this.destination;
	                destination.add(iterator.subscribe());
	            }
	            else {
	                this.active--;
	            }
	        }
	    };
	    ZipSubscriber.prototype.notifyInactive = function () {
	        this.active--;
	        if (this.active === 0) {
	            this.destination.complete();
	        }
	    };
	    ZipSubscriber.prototype.checkIterators = function () {
	        var iterators = this.iterators;
	        var len = iterators.length;
	        var destination = this.destination;
	        for (var i = 0; i < len; i++) {
	            var iterator = iterators[i];
	            if (typeof iterator.hasValue === 'function' && !iterator.hasValue()) {
	                return;
	            }
	        }
	        var shouldComplete = false;
	        var args = [];
	        for (var i = 0; i < len; i++) {
	            var iterator = iterators[i];
	            var result = iterator.next();
	            if (iterator.hasCompleted()) {
	                shouldComplete = true;
	            }
	            if (result.done) {
	                destination.complete();
	                return;
	            }
	            args.push(result.value);
	        }
	        if (this.resultSelector) {
	            this._tryresultSelector(args);
	        }
	        else {
	            destination.next(args);
	        }
	        if (shouldComplete) {
	            destination.complete();
	        }
	    };
	    ZipSubscriber.prototype._tryresultSelector = function (args) {
	        var result;
	        try {
	            result = this.resultSelector.apply(this, args);
	        }
	        catch (err) {
	            this.destination.error(err);
	            return;
	        }
	        this.destination.next(result);
	    };
	    return ZipSubscriber;
	}(Subscriber));
	var StaticIterator = /*@__PURE__*/ (function () {
	    function StaticIterator(iterator) {
	        this.iterator = iterator;
	        this.nextResult = iterator.next();
	    }
	    StaticIterator.prototype.hasValue = function () {
	        return true;
	    };
	    StaticIterator.prototype.next = function () {
	        var result = this.nextResult;
	        this.nextResult = this.iterator.next();
	        return result;
	    };
	    StaticIterator.prototype.hasCompleted = function () {
	        var nextResult = this.nextResult;
	        return Boolean(nextResult && nextResult.done);
	    };
	    return StaticIterator;
	}());
	var StaticArrayIterator = /*@__PURE__*/ (function () {
	    function StaticArrayIterator(array) {
	        this.array = array;
	        this.index = 0;
	        this.length = 0;
	        this.length = array.length;
	    }
	    StaticArrayIterator.prototype[iterator] = function () {
	        return this;
	    };
	    StaticArrayIterator.prototype.next = function (value) {
	        var i = this.index++;
	        var array = this.array;
	        return i < this.length ? { value: array[i], done: false } : { value: null, done: true };
	    };
	    StaticArrayIterator.prototype.hasValue = function () {
	        return this.array.length > this.index;
	    };
	    StaticArrayIterator.prototype.hasCompleted = function () {
	        return this.array.length === this.index;
	    };
	    return StaticArrayIterator;
	}());
	var ZipBufferIterator = /*@__PURE__*/ (function (_super) {
	    __extends(ZipBufferIterator, _super);
	    function ZipBufferIterator(destination, parent, observable) {
	        var _this = _super.call(this, destination) || this;
	        _this.parent = parent;
	        _this.observable = observable;
	        _this.stillUnsubscribed = true;
	        _this.buffer = [];
	        _this.isComplete = false;
	        return _this;
	    }
	    ZipBufferIterator.prototype[iterator] = function () {
	        return this;
	    };
	    ZipBufferIterator.prototype.next = function () {
	        var buffer = this.buffer;
	        if (buffer.length === 0 && this.isComplete) {
	            return { value: null, done: true };
	        }
	        else {
	            return { value: buffer.shift(), done: false };
	        }
	    };
	    ZipBufferIterator.prototype.hasValue = function () {
	        return this.buffer.length > 0;
	    };
	    ZipBufferIterator.prototype.hasCompleted = function () {
	        return this.buffer.length === 0 && this.isComplete;
	    };
	    ZipBufferIterator.prototype.notifyComplete = function () {
	        if (this.buffer.length > 0) {
	            this.isComplete = true;
	            this.parent.notifyInactive();
	        }
	        else {
	            this.destination.complete();
	        }
	    };
	    ZipBufferIterator.prototype.notifyNext = function (innerValue) {
	        this.buffer.push(innerValue);
	        this.parent.checkIterators();
	    };
	    ZipBufferIterator.prototype.subscribe = function () {
	        return innerSubscribe(this.observable, new SimpleInnerSubscriber(this));
	    };
	    return ZipBufferIterator;
	}(SimpleOuterSubscriber));

	/** PURE_IMPORTS_START _observable_zip PURE_IMPORTS_END */
	function zip() {
	    var observables = [];
	    for (var _i = 0; _i < arguments.length; _i++) {
	        observables[_i] = arguments[_i];
	    }
	    return function zipOperatorFunction(source) {
	        return source.lift.call(zip$1.apply(void 0, [source].concat(observables)));
	    };
	}

	/** PURE_IMPORTS_START _observable_zip PURE_IMPORTS_END */
	function zipAll(project) {
	    return function (source) { return source.lift(new ZipOperator(project)); };
	}

	/** PURE_IMPORTS_START  PURE_IMPORTS_END */

	var operators = /*#__PURE__*/Object.freeze({
		__proto__: null,
		audit: audit,
		auditTime: auditTime,
		buffer: buffer,
		bufferCount: bufferCount,
		bufferTime: bufferTime,
		bufferToggle: bufferToggle,
		bufferWhen: bufferWhen,
		catchError: catchError,
		combineAll: combineAll,
		combineLatest: combineLatest,
		concat: concat,
		concatAll: concatAll,
		concatMap: concatMap,
		concatMapTo: concatMapTo,
		count: count,
		debounce: debounce,
		debounceTime: debounceTime,
		defaultIfEmpty: defaultIfEmpty,
		delay: delay,
		delayWhen: delayWhen,
		dematerialize: dematerialize,
		distinct: distinct,
		distinctUntilChanged: distinctUntilChanged,
		distinctUntilKeyChanged: distinctUntilKeyChanged,
		elementAt: elementAt,
		endWith: endWith,
		every: every,
		exhaust: exhaust,
		exhaustMap: exhaustMap,
		expand: expand,
		filter: filter,
		finalize: finalize,
		find: find,
		findIndex: findIndex,
		first: first,
		flatMap: flatMap,
		groupBy: groupBy,
		ignoreElements: ignoreElements,
		isEmpty: isEmpty,
		last: last,
		map: map,
		mapTo: mapTo,
		materialize: materialize,
		max: max,
		merge: merge,
		mergeAll: mergeAll,
		mergeMap: mergeMap,
		mergeMapTo: mergeMapTo,
		mergeScan: mergeScan,
		min: min,
		multicast: multicast,
		observeOn: observeOn,
		onErrorResumeNext: onErrorResumeNext,
		pairwise: pairwise,
		partition: partition,
		pluck: pluck,
		publish: publish,
		publishBehavior: publishBehavior,
		publishLast: publishLast,
		publishReplay: publishReplay,
		race: race,
		reduce: reduce,
		refCount: refCount,
		repeat: repeat,
		repeatWhen: repeatWhen,
		retry: retry,
		retryWhen: retryWhen,
		sample: sample,
		sampleTime: sampleTime,
		scan: scan,
		sequenceEqual: sequenceEqual,
		share: share,
		shareReplay: shareReplay,
		single: single,
		skip: skip,
		skipLast: skipLast,
		skipUntil: skipUntil,
		skipWhile: skipWhile,
		startWith: startWith,
		subscribeOn: subscribeOn,
		switchAll: switchAll,
		switchMap: switchMap,
		switchMapTo: switchMapTo,
		take: take,
		takeLast: takeLast,
		takeUntil: takeUntil,
		takeWhile: takeWhile,
		tap: tap,
		throttle: throttle,
		throttleTime: throttleTime,
		throwIfEmpty: throwIfEmpty,
		timeInterval: timeInterval,
		timeout: timeout,
		timeoutWith: timeoutWith,
		timestamp: timestamp,
		toArray: toArray,
		window: window$1,
		windowCount: windowCount,
		windowTime: windowTime,
		windowToggle: windowToggle,
		windowWhen: windowWhen,
		withLatestFrom: withLatestFrom,
		zip: zip,
		zipAll: zipAll
	});

	var require$$1 = /*@__PURE__*/getAugmentedNamespace(operators);

	var rngBrowser = {exports: {}};

	// Unique ID creation requires a high quality random # generator.  In the
	// browser this is a little complicated due to unknown quality of Math.random()
	// and inconsistent support for the `crypto` API.  We do the best we can via
	// feature-detection

	// getRandomValues needs to be invoked in a context where "this" is a Crypto
	// implementation. Also, find the complete implementation of crypto on IE11.
	var getRandomValues = (typeof(crypto) != 'undefined' && crypto.getRandomValues && crypto.getRandomValues.bind(crypto)) ||
	                      (typeof(msCrypto) != 'undefined' && typeof window.msCrypto.getRandomValues == 'function' && msCrypto.getRandomValues.bind(msCrypto));

	if (getRandomValues) {
	  // WHATWG crypto RNG - http://wiki.whatwg.org/wiki/Crypto
	  var rnds8 = new Uint8Array(16); // eslint-disable-line no-undef

	  rngBrowser.exports = function whatwgRNG() {
	    getRandomValues(rnds8);
	    return rnds8;
	  };
	} else {
	  // Math.random()-based (RNG)
	  //
	  // If all else fails, use Math.random().  It's fast, but is of unspecified
	  // quality.
	  var rnds = new Array(16);

	  rngBrowser.exports = function mathRNG() {
	    for (var i = 0, r; i < 16; i++) {
	      if ((i & 0x03) === 0) r = Math.random() * 0x100000000;
	      rnds[i] = r >>> ((i & 0x03) << 3) & 0xff;
	    }

	    return rnds;
	  };
	}

	var rngBrowserExports = rngBrowser.exports;

	/**
	 * Convert array of 16 byte values to UUID string format of the form:
	 * XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX
	 */

	var byteToHex = [];
	for (var i = 0; i < 256; ++i) {
	  byteToHex[i] = (i + 0x100).toString(16).substr(1);
	}

	function bytesToUuid$2(buf, offset) {
	  var i = offset || 0;
	  var bth = byteToHex;
	  // join used to fix memory issue caused by concatenation: https://bugs.chromium.org/p/v8/issues/detail?id=3175#c4
	  return ([
	    bth[buf[i++]], bth[buf[i++]],
	    bth[buf[i++]], bth[buf[i++]], '-',
	    bth[buf[i++]], bth[buf[i++]], '-',
	    bth[buf[i++]], bth[buf[i++]], '-',
	    bth[buf[i++]], bth[buf[i++]], '-',
	    bth[buf[i++]], bth[buf[i++]],
	    bth[buf[i++]], bth[buf[i++]],
	    bth[buf[i++]], bth[buf[i++]]
	  ]).join('');
	}

	var bytesToUuid_1 = bytesToUuid$2;

	var rng$1 = rngBrowserExports;
	var bytesToUuid$1 = bytesToUuid_1;

	// **`v1()` - Generate time-based UUID**
	//
	// Inspired by https://github.com/LiosK/UUID.js
	// and http://docs.python.org/library/uuid.html

	var _nodeId;
	var _clockseq;

	// Previous uuid creation time
	var _lastMSecs = 0;
	var _lastNSecs = 0;

	// See https://github.com/uuidjs/uuid for API details
	function v1$1(options, buf, offset) {
	  var i = buf && offset || 0;
	  var b = buf || [];

	  options = options || {};
	  var node = options.node || _nodeId;
	  var clockseq = options.clockseq !== undefined ? options.clockseq : _clockseq;

	  // node and clockseq need to be initialized to random values if they're not
	  // specified.  We do this lazily to minimize issues related to insufficient
	  // system entropy.  See #189
	  if (node == null || clockseq == null) {
	    var seedBytes = rng$1();
	    if (node == null) {
	      // Per 4.5, create and 48-bit node id, (47 random bits + multicast bit = 1)
	      node = _nodeId = [
	        seedBytes[0] | 0x01,
	        seedBytes[1], seedBytes[2], seedBytes[3], seedBytes[4], seedBytes[5]
	      ];
	    }
	    if (clockseq == null) {
	      // Per 4.2.2, randomize (14 bit) clockseq
	      clockseq = _clockseq = (seedBytes[6] << 8 | seedBytes[7]) & 0x3fff;
	    }
	  }

	  // UUID timestamps are 100 nano-second units since the Gregorian epoch,
	  // (1582-10-15 00:00).  JSNumbers aren't precise enough for this, so
	  // time is handled internally as 'msecs' (integer milliseconds) and 'nsecs'
	  // (100-nanoseconds offset from msecs) since unix epoch, 1970-01-01 00:00.
	  var msecs = options.msecs !== undefined ? options.msecs : new Date().getTime();

	  // Per 4.2.1.2, use count of uuid's generated during the current clock
	  // cycle to simulate higher resolution clock
	  var nsecs = options.nsecs !== undefined ? options.nsecs : _lastNSecs + 1;

	  // Time since last uuid creation (in msecs)
	  var dt = (msecs - _lastMSecs) + (nsecs - _lastNSecs)/10000;

	  // Per 4.2.1.2, Bump clockseq on clock regression
	  if (dt < 0 && options.clockseq === undefined) {
	    clockseq = clockseq + 1 & 0x3fff;
	  }

	  // Reset nsecs if clock regresses (new clockseq) or we've moved onto a new
	  // time interval
	  if ((dt < 0 || msecs > _lastMSecs) && options.nsecs === undefined) {
	    nsecs = 0;
	  }

	  // Per 4.2.1.2 Throw error if too many uuids are requested
	  if (nsecs >= 10000) {
	    throw new Error('uuid.v1(): Can\'t create more than 10M uuids/sec');
	  }

	  _lastMSecs = msecs;
	  _lastNSecs = nsecs;
	  _clockseq = clockseq;

	  // Per 4.1.4 - Convert from unix epoch to Gregorian epoch
	  msecs += 12219292800000;

	  // `time_low`
	  var tl = ((msecs & 0xfffffff) * 10000 + nsecs) % 0x100000000;
	  b[i++] = tl >>> 24 & 0xff;
	  b[i++] = tl >>> 16 & 0xff;
	  b[i++] = tl >>> 8 & 0xff;
	  b[i++] = tl & 0xff;

	  // `time_mid`
	  var tmh = (msecs / 0x100000000 * 10000) & 0xfffffff;
	  b[i++] = tmh >>> 8 & 0xff;
	  b[i++] = tmh & 0xff;

	  // `time_high_and_version`
	  b[i++] = tmh >>> 24 & 0xf | 0x10; // include version
	  b[i++] = tmh >>> 16 & 0xff;

	  // `clock_seq_hi_and_reserved` (Per 4.2.2 - include variant)
	  b[i++] = clockseq >>> 8 | 0x80;

	  // `clock_seq_low`
	  b[i++] = clockseq & 0xff;

	  // `node`
	  for (var n = 0; n < 6; ++n) {
	    b[i + n] = node[n];
	  }

	  return buf ? buf : bytesToUuid$1(b);
	}

	var v1_1 = v1$1;

	var rng = rngBrowserExports;
	var bytesToUuid = bytesToUuid_1;

	function v4$1(options, buf, offset) {
	  var i = buf && offset || 0;

	  if (typeof(options) == 'string') {
	    buf = options === 'binary' ? new Array(16) : null;
	    options = null;
	  }
	  options = options || {};

	  var rnds = options.random || (options.rng || rng)();

	  // Per 4.4, set bits for version and `clock_seq_hi_and_reserved`
	  rnds[6] = (rnds[6] & 0x0f) | 0x40;
	  rnds[8] = (rnds[8] & 0x3f) | 0x80;

	  // Copy bytes to buffer, if provided
	  if (buf) {
	    for (var ii = 0; ii < 16; ++ii) {
	      buf[i + ii] = rnds[ii];
	    }
	  }

	  return buf || bytesToUuid(rnds);
	}

	var v4_1 = v4$1;

	var v1 = v1_1;
	var v4 = v4_1;

	var uuid = v4;
	uuid.v1 = v1;
	uuid.v4 = v4;

	var uuid_1$1 = uuid;

	var cryptoJs = {exports: {}};

	var core = {exports: {}};

	var hasRequiredCore;

	function requireCore () {
		if (hasRequiredCore) return core.exports;
		hasRequiredCore = 1;
		(function (module, exports) {
	(function (root, factory) {
				{
					// CommonJS
					module.exports = factory();
				}
			}(commonjsGlobal, function () {

				/**
				 * CryptoJS core components.
				 */
				var CryptoJS = CryptoJS || (function (Math, undefined$1) {
				    /*
				     * Local polyfil of Object.create
				     */
				    var create = Object.create || (function () {
				        function F() {}
				        return function (obj) {
				            var subtype;

				            F.prototype = obj;

				            subtype = new F();

				            F.prototype = null;

				            return subtype;
				        };
				    }());

				    /**
				     * CryptoJS namespace.
				     */
				    var C = {};

				    /**
				     * Library namespace.
				     */
				    var C_lib = C.lib = {};

				    /**
				     * Base object for prototypal inheritance.
				     */
				    var Base = C_lib.Base = (function () {


				        return {
				            /**
				             * Creates a new object that inherits from this object.
				             *
				             * @param {Object} overrides Properties to copy into the new object.
				             *
				             * @return {Object} The new object.
				             *
				             * @static
				             *
				             * @example
				             *
				             *     var MyType = CryptoJS.lib.Base.extend({
				             *         field: 'value',
				             *
				             *         method: function () {
				             *         }
				             *     });
				             */
				            extend: function (overrides) {
				                // Spawn
				                var subtype = create(this);

				                // Augment
				                if (overrides) {
				                    subtype.mixIn(overrides);
				                }

				                // Create default initializer
				                if (!subtype.hasOwnProperty('init') || this.init === subtype.init) {
				                    subtype.init = function () {
				                        subtype.$super.init.apply(this, arguments);
				                    };
				                }

				                // Initializer's prototype is the subtype object
				                subtype.init.prototype = subtype;

				                // Reference supertype
				                subtype.$super = this;

				                return subtype;
				            },

				            /**
				             * Extends this object and runs the init method.
				             * Arguments to create() will be passed to init().
				             *
				             * @return {Object} The new object.
				             *
				             * @static
				             *
				             * @example
				             *
				             *     var instance = MyType.create();
				             */
				            create: function () {
				                var instance = this.extend();
				                instance.init.apply(instance, arguments);

				                return instance;
				            },

				            /**
				             * Initializes a newly created object.
				             * Override this method to add some logic when your objects are created.
				             *
				             * @example
				             *
				             *     var MyType = CryptoJS.lib.Base.extend({
				             *         init: function () {
				             *             // ...
				             *         }
				             *     });
				             */
				            init: function () {
				            },

				            /**
				             * Copies properties into this object.
				             *
				             * @param {Object} properties The properties to mix in.
				             *
				             * @example
				             *
				             *     MyType.mixIn({
				             *         field: 'value'
				             *     });
				             */
				            mixIn: function (properties) {
				                for (var propertyName in properties) {
				                    if (properties.hasOwnProperty(propertyName)) {
				                        this[propertyName] = properties[propertyName];
				                    }
				                }

				                // IE won't copy toString using the loop above
				                if (properties.hasOwnProperty('toString')) {
				                    this.toString = properties.toString;
				                }
				            },

				            /**
				             * Creates a copy of this object.
				             *
				             * @return {Object} The clone.
				             *
				             * @example
				             *
				             *     var clone = instance.clone();
				             */
				            clone: function () {
				                return this.init.prototype.extend(this);
				            }
				        };
				    }());

				    /**
				     * An array of 32-bit words.
				     *
				     * @property {Array} words The array of 32-bit words.
				     * @property {number} sigBytes The number of significant bytes in this word array.
				     */
				    var WordArray = C_lib.WordArray = Base.extend({
				        /**
				         * Initializes a newly created word array.
				         *
				         * @param {Array} words (Optional) An array of 32-bit words.
				         * @param {number} sigBytes (Optional) The number of significant bytes in the words.
				         *
				         * @example
				         *
				         *     var wordArray = CryptoJS.lib.WordArray.create();
				         *     var wordArray = CryptoJS.lib.WordArray.create([0x00010203, 0x04050607]);
				         *     var wordArray = CryptoJS.lib.WordArray.create([0x00010203, 0x04050607], 6);
				         */
				        init: function (words, sigBytes) {
				            words = this.words = words || [];

				            if (sigBytes != undefined$1) {
				                this.sigBytes = sigBytes;
				            } else {
				                this.sigBytes = words.length * 4;
				            }
				        },

				        /**
				         * Converts this word array to a string.
				         *
				         * @param {Encoder} encoder (Optional) The encoding strategy to use. Default: CryptoJS.enc.Hex
				         *
				         * @return {string} The stringified word array.
				         *
				         * @example
				         *
				         *     var string = wordArray + '';
				         *     var string = wordArray.toString();
				         *     var string = wordArray.toString(CryptoJS.enc.Utf8);
				         */
				        toString: function (encoder) {
				            return (encoder || Hex).stringify(this);
				        },

				        /**
				         * Concatenates a word array to this word array.
				         *
				         * @param {WordArray} wordArray The word array to append.
				         *
				         * @return {WordArray} This word array.
				         *
				         * @example
				         *
				         *     wordArray1.concat(wordArray2);
				         */
				        concat: function (wordArray) {
				            // Shortcuts
				            var thisWords = this.words;
				            var thatWords = wordArray.words;
				            var thisSigBytes = this.sigBytes;
				            var thatSigBytes = wordArray.sigBytes;

				            // Clamp excess bits
				            this.clamp();

				            // Concat
				            if (thisSigBytes % 4) {
				                // Copy one byte at a time
				                for (var i = 0; i < thatSigBytes; i++) {
				                    var thatByte = (thatWords[i >>> 2] >>> (24 - (i % 4) * 8)) & 0xff;
				                    thisWords[(thisSigBytes + i) >>> 2] |= thatByte << (24 - ((thisSigBytes + i) % 4) * 8);
				                }
				            } else {
				                // Copy one word at a time
				                for (var i = 0; i < thatSigBytes; i += 4) {
				                    thisWords[(thisSigBytes + i) >>> 2] = thatWords[i >>> 2];
				                }
				            }
				            this.sigBytes += thatSigBytes;

				            // Chainable
				            return this;
				        },

				        /**
				         * Removes insignificant bits.
				         *
				         * @example
				         *
				         *     wordArray.clamp();
				         */
				        clamp: function () {
				            // Shortcuts
				            var words = this.words;
				            var sigBytes = this.sigBytes;

				            // Clamp
				            words[sigBytes >>> 2] &= 0xffffffff << (32 - (sigBytes % 4) * 8);
				            words.length = Math.ceil(sigBytes / 4);
				        },

				        /**
				         * Creates a copy of this word array.
				         *
				         * @return {WordArray} The clone.
				         *
				         * @example
				         *
				         *     var clone = wordArray.clone();
				         */
				        clone: function () {
				            var clone = Base.clone.call(this);
				            clone.words = this.words.slice(0);

				            return clone;
				        },

				        /**
				         * Creates a word array filled with random bytes.
				         *
				         * @param {number} nBytes The number of random bytes to generate.
				         *
				         * @return {WordArray} The random word array.
				         *
				         * @static
				         *
				         * @example
				         *
				         *     var wordArray = CryptoJS.lib.WordArray.random(16);
				         */
				        random: function (nBytes) {
				            var words = [];

				            var r = (function (m_w) {
				                var m_w = m_w;
				                var m_z = 0x3ade68b1;
				                var mask = 0xffffffff;

				                return function () {
				                    m_z = (0x9069 * (m_z & 0xFFFF) + (m_z >> 0x10)) & mask;
				                    m_w = (0x4650 * (m_w & 0xFFFF) + (m_w >> 0x10)) & mask;
				                    var result = ((m_z << 0x10) + m_w) & mask;
				                    result /= 0x100000000;
				                    result += 0.5;
				                    return result * (Math.random() > .5 ? 1 : -1);
				                }
				            });

				            for (var i = 0, rcache; i < nBytes; i += 4) {
				                var _r = r((rcache || Math.random()) * 0x100000000);

				                rcache = _r() * 0x3ade67b7;
				                words.push((_r() * 0x100000000) | 0);
				            }

				            return new WordArray.init(words, nBytes);
				        }
				    });

				    /**
				     * Encoder namespace.
				     */
				    var C_enc = C.enc = {};

				    /**
				     * Hex encoding strategy.
				     */
				    var Hex = C_enc.Hex = {
				        /**
				         * Converts a word array to a hex string.
				         *
				         * @param {WordArray} wordArray The word array.
				         *
				         * @return {string} The hex string.
				         *
				         * @static
				         *
				         * @example
				         *
				         *     var hexString = CryptoJS.enc.Hex.stringify(wordArray);
				         */
				        stringify: function (wordArray) {
				            // Shortcuts
				            var words = wordArray.words;
				            var sigBytes = wordArray.sigBytes;

				            // Convert
				            var hexChars = [];
				            for (var i = 0; i < sigBytes; i++) {
				                var bite = (words[i >>> 2] >>> (24 - (i % 4) * 8)) & 0xff;
				                hexChars.push((bite >>> 4).toString(16));
				                hexChars.push((bite & 0x0f).toString(16));
				            }

				            return hexChars.join('');
				        },

				        /**
				         * Converts a hex string to a word array.
				         *
				         * @param {string} hexStr The hex string.
				         *
				         * @return {WordArray} The word array.
				         *
				         * @static
				         *
				         * @example
				         *
				         *     var wordArray = CryptoJS.enc.Hex.parse(hexString);
				         */
				        parse: function (hexStr) {
				            // Shortcut
				            var hexStrLength = hexStr.length;

				            // Convert
				            var words = [];
				            for (var i = 0; i < hexStrLength; i += 2) {
				                words[i >>> 3] |= parseInt(hexStr.substr(i, 2), 16) << (24 - (i % 8) * 4);
				            }

				            return new WordArray.init(words, hexStrLength / 2);
				        }
				    };

				    /**
				     * Latin1 encoding strategy.
				     */
				    var Latin1 = C_enc.Latin1 = {
				        /**
				         * Converts a word array to a Latin1 string.
				         *
				         * @param {WordArray} wordArray The word array.
				         *
				         * @return {string} The Latin1 string.
				         *
				         * @static
				         *
				         * @example
				         *
				         *     var latin1String = CryptoJS.enc.Latin1.stringify(wordArray);
				         */
				        stringify: function (wordArray) {
				            // Shortcuts
				            var words = wordArray.words;
				            var sigBytes = wordArray.sigBytes;

				            // Convert
				            var latin1Chars = [];
				            for (var i = 0; i < sigBytes; i++) {
				                var bite = (words[i >>> 2] >>> (24 - (i % 4) * 8)) & 0xff;
				                latin1Chars.push(String.fromCharCode(bite));
				            }

				            return latin1Chars.join('');
				        },

				        /**
				         * Converts a Latin1 string to a word array.
				         *
				         * @param {string} latin1Str The Latin1 string.
				         *
				         * @return {WordArray} The word array.
				         *
				         * @static
				         *
				         * @example
				         *
				         *     var wordArray = CryptoJS.enc.Latin1.parse(latin1String);
				         */
				        parse: function (latin1Str) {
				            // Shortcut
				            var latin1StrLength = latin1Str.length;

				            // Convert
				            var words = [];
				            for (var i = 0; i < latin1StrLength; i++) {
				                words[i >>> 2] |= (latin1Str.charCodeAt(i) & 0xff) << (24 - (i % 4) * 8);
				            }

				            return new WordArray.init(words, latin1StrLength);
				        }
				    };

				    /**
				     * UTF-8 encoding strategy.
				     */
				    var Utf8 = C_enc.Utf8 = {
				        /**
				         * Converts a word array to a UTF-8 string.
				         *
				         * @param {WordArray} wordArray The word array.
				         *
				         * @return {string} The UTF-8 string.
				         *
				         * @static
				         *
				         * @example
				         *
				         *     var utf8String = CryptoJS.enc.Utf8.stringify(wordArray);
				         */
				        stringify: function (wordArray) {
				            try {
				                return decodeURIComponent(escape(Latin1.stringify(wordArray)));
				            } catch (e) {
				                throw new Error('Malformed UTF-8 data');
				            }
				        },

				        /**
				         * Converts a UTF-8 string to a word array.
				         *
				         * @param {string} utf8Str The UTF-8 string.
				         *
				         * @return {WordArray} The word array.
				         *
				         * @static
				         *
				         * @example
				         *
				         *     var wordArray = CryptoJS.enc.Utf8.parse(utf8String);
				         */
				        parse: function (utf8Str) {
				            return Latin1.parse(unescape(encodeURIComponent(utf8Str)));
				        }
				    };

				    /**
				     * Abstract buffered block algorithm template.
				     *
				     * The property blockSize must be implemented in a concrete subtype.
				     *
				     * @property {number} _minBufferSize The number of blocks that should be kept unprocessed in the buffer. Default: 0
				     */
				    var BufferedBlockAlgorithm = C_lib.BufferedBlockAlgorithm = Base.extend({
				        /**
				         * Resets this block algorithm's data buffer to its initial state.
				         *
				         * @example
				         *
				         *     bufferedBlockAlgorithm.reset();
				         */
				        reset: function () {
				            // Initial values
				            this._data = new WordArray.init();
				            this._nDataBytes = 0;
				        },

				        /**
				         * Adds new data to this block algorithm's buffer.
				         *
				         * @param {WordArray|string} data The data to append. Strings are converted to a WordArray using UTF-8.
				         *
				         * @example
				         *
				         *     bufferedBlockAlgorithm._append('data');
				         *     bufferedBlockAlgorithm._append(wordArray);
				         */
				        _append: function (data) {
				            // Convert string to WordArray, else assume WordArray already
				            if (typeof data == 'string') {
				                data = Utf8.parse(data);
				            }

				            // Append
				            this._data.concat(data);
				            this._nDataBytes += data.sigBytes;
				        },

				        /**
				         * Processes available data blocks.
				         *
				         * This method invokes _doProcessBlock(offset), which must be implemented by a concrete subtype.
				         *
				         * @param {boolean} doFlush Whether all blocks and partial blocks should be processed.
				         *
				         * @return {WordArray} The processed data.
				         *
				         * @example
				         *
				         *     var processedData = bufferedBlockAlgorithm._process();
				         *     var processedData = bufferedBlockAlgorithm._process(!!'flush');
				         */
				        _process: function (doFlush) {
				            // Shortcuts
				            var data = this._data;
				            var dataWords = data.words;
				            var dataSigBytes = data.sigBytes;
				            var blockSize = this.blockSize;
				            var blockSizeBytes = blockSize * 4;

				            // Count blocks ready
				            var nBlocksReady = dataSigBytes / blockSizeBytes;
				            if (doFlush) {
				                // Round up to include partial blocks
				                nBlocksReady = Math.ceil(nBlocksReady);
				            } else {
				                // Round down to include only full blocks,
				                // less the number of blocks that must remain in the buffer
				                nBlocksReady = Math.max((nBlocksReady | 0) - this._minBufferSize, 0);
				            }

				            // Count words ready
				            var nWordsReady = nBlocksReady * blockSize;

				            // Count bytes ready
				            var nBytesReady = Math.min(nWordsReady * 4, dataSigBytes);

				            // Process blocks
				            if (nWordsReady) {
				                for (var offset = 0; offset < nWordsReady; offset += blockSize) {
				                    // Perform concrete-algorithm logic
				                    this._doProcessBlock(dataWords, offset);
				                }

				                // Remove processed words
				                var processedWords = dataWords.splice(0, nWordsReady);
				                data.sigBytes -= nBytesReady;
				            }

				            // Return processed words
				            return new WordArray.init(processedWords, nBytesReady);
				        },

				        /**
				         * Creates a copy of this object.
				         *
				         * @return {Object} The clone.
				         *
				         * @example
				         *
				         *     var clone = bufferedBlockAlgorithm.clone();
				         */
				        clone: function () {
				            var clone = Base.clone.call(this);
				            clone._data = this._data.clone();

				            return clone;
				        },

				        _minBufferSize: 0
				    });

				    /**
				     * Abstract hasher template.
				     *
				     * @property {number} blockSize The number of 32-bit words this hasher operates on. Default: 16 (512 bits)
				     */
				    C_lib.Hasher = BufferedBlockAlgorithm.extend({
				        /**
				         * Configuration options.
				         */
				        cfg: Base.extend(),

				        /**
				         * Initializes a newly created hasher.
				         *
				         * @param {Object} cfg (Optional) The configuration options to use for this hash computation.
				         *
				         * @example
				         *
				         *     var hasher = CryptoJS.algo.SHA256.create();
				         */
				        init: function (cfg) {
				            // Apply config defaults
				            this.cfg = this.cfg.extend(cfg);

				            // Set initial values
				            this.reset();
				        },

				        /**
				         * Resets this hasher to its initial state.
				         *
				         * @example
				         *
				         *     hasher.reset();
				         */
				        reset: function () {
				            // Reset data buffer
				            BufferedBlockAlgorithm.reset.call(this);

				            // Perform concrete-hasher logic
				            this._doReset();
				        },

				        /**
				         * Updates this hasher with a message.
				         *
				         * @param {WordArray|string} messageUpdate The message to append.
				         *
				         * @return {Hasher} This hasher.
				         *
				         * @example
				         *
				         *     hasher.update('message');
				         *     hasher.update(wordArray);
				         */
				        update: function (messageUpdate) {
				            // Append
				            this._append(messageUpdate);

				            // Update the hash
				            this._process();

				            // Chainable
				            return this;
				        },

				        /**
				         * Finalizes the hash computation.
				         * Note that the finalize operation is effectively a destructive, read-once operation.
				         *
				         * @param {WordArray|string} messageUpdate (Optional) A final message update.
				         *
				         * @return {WordArray} The hash.
				         *
				         * @example
				         *
				         *     var hash = hasher.finalize();
				         *     var hash = hasher.finalize('message');
				         *     var hash = hasher.finalize(wordArray);
				         */
				        finalize: function (messageUpdate) {
				            // Final message update
				            if (messageUpdate) {
				                this._append(messageUpdate);
				            }

				            // Perform concrete-hasher logic
				            var hash = this._doFinalize();

				            return hash;
				        },

				        blockSize: 512/32,

				        /**
				         * Creates a shortcut function to a hasher's object interface.
				         *
				         * @param {Hasher} hasher The hasher to create a helper for.
				         *
				         * @return {Function} The shortcut function.
				         *
				         * @static
				         *
				         * @example
				         *
				         *     var SHA256 = CryptoJS.lib.Hasher._createHelper(CryptoJS.algo.SHA256);
				         */
				        _createHelper: function (hasher) {
				            return function (message, cfg) {
				                return new hasher.init(cfg).finalize(message);
				            };
				        },

				        /**
				         * Creates a shortcut function to the HMAC's object interface.
				         *
				         * @param {Hasher} hasher The hasher to use in this HMAC helper.
				         *
				         * @return {Function} The shortcut function.
				         *
				         * @static
				         *
				         * @example
				         *
				         *     var HmacSHA256 = CryptoJS.lib.Hasher._createHmacHelper(CryptoJS.algo.SHA256);
				         */
				        _createHmacHelper: function (hasher) {
				            return function (message, key) {
				                return new C_algo.HMAC.init(hasher, key).finalize(message);
				            };
				        }
				    });

				    /**
				     * Algorithm namespace.
				     */
				    var C_algo = C.algo = {};

				    return C;
				}(Math));


				return CryptoJS;

			}));
		} (core));
		return core.exports;
	}

	var x64Core = {exports: {}};

	var hasRequiredX64Core;

	function requireX64Core () {
		if (hasRequiredX64Core) return x64Core.exports;
		hasRequiredX64Core = 1;
		(function (module, exports) {
	(function (root, factory) {
				{
					// CommonJS
					module.exports = factory(requireCore());
				}
			}(commonjsGlobal, function (CryptoJS) {

				(function (undefined$1) {
				    // Shortcuts
				    var C = CryptoJS;
				    var C_lib = C.lib;
				    var Base = C_lib.Base;
				    var X32WordArray = C_lib.WordArray;

				    /**
				     * x64 namespace.
				     */
				    var C_x64 = C.x64 = {};

				    /**
				     * A 64-bit word.
				     */
				    C_x64.Word = Base.extend({
				        /**
				         * Initializes a newly created 64-bit word.
				         *
				         * @param {number} high The high 32 bits.
				         * @param {number} low The low 32 bits.
				         *
				         * @example
				         *
				         *     var x64Word = CryptoJS.x64.Word.create(0x00010203, 0x04050607);
				         */
				        init: function (high, low) {
				            this.high = high;
				            this.low = low;
				        }

				        /**
				         * Bitwise NOTs this word.
				         *
				         * @return {X64Word} A new x64-Word object after negating.
				         *
				         * @example
				         *
				         *     var negated = x64Word.not();
				         */
				        // not: function () {
				            // var high = ~this.high;
				            // var low = ~this.low;

				            // return X64Word.create(high, low);
				        // },

				        /**
				         * Bitwise ANDs this word with the passed word.
				         *
				         * @param {X64Word} word The x64-Word to AND with this word.
				         *
				         * @return {X64Word} A new x64-Word object after ANDing.
				         *
				         * @example
				         *
				         *     var anded = x64Word.and(anotherX64Word);
				         */
				        // and: function (word) {
				            // var high = this.high & word.high;
				            // var low = this.low & word.low;

				            // return X64Word.create(high, low);
				        // },

				        /**
				         * Bitwise ORs this word with the passed word.
				         *
				         * @param {X64Word} word The x64-Word to OR with this word.
				         *
				         * @return {X64Word} A new x64-Word object after ORing.
				         *
				         * @example
				         *
				         *     var ored = x64Word.or(anotherX64Word);
				         */
				        // or: function (word) {
				            // var high = this.high | word.high;
				            // var low = this.low | word.low;

				            // return X64Word.create(high, low);
				        // },

				        /**
				         * Bitwise XORs this word with the passed word.
				         *
				         * @param {X64Word} word The x64-Word to XOR with this word.
				         *
				         * @return {X64Word} A new x64-Word object after XORing.
				         *
				         * @example
				         *
				         *     var xored = x64Word.xor(anotherX64Word);
				         */
				        // xor: function (word) {
				            // var high = this.high ^ word.high;
				            // var low = this.low ^ word.low;

				            // return X64Word.create(high, low);
				        // },

				        /**
				         * Shifts this word n bits to the left.
				         *
				         * @param {number} n The number of bits to shift.
				         *
				         * @return {X64Word} A new x64-Word object after shifting.
				         *
				         * @example
				         *
				         *     var shifted = x64Word.shiftL(25);
				         */
				        // shiftL: function (n) {
				            // if (n < 32) {
				                // var high = (this.high << n) | (this.low >>> (32 - n));
				                // var low = this.low << n;
				            // } else {
				                // var high = this.low << (n - 32);
				                // var low = 0;
				            // }

				            // return X64Word.create(high, low);
				        // },

				        /**
				         * Shifts this word n bits to the right.
				         *
				         * @param {number} n The number of bits to shift.
				         *
				         * @return {X64Word} A new x64-Word object after shifting.
				         *
				         * @example
				         *
				         *     var shifted = x64Word.shiftR(7);
				         */
				        // shiftR: function (n) {
				            // if (n < 32) {
				                // var low = (this.low >>> n) | (this.high << (32 - n));
				                // var high = this.high >>> n;
				            // } else {
				                // var low = this.high >>> (n - 32);
				                // var high = 0;
				            // }

				            // return X64Word.create(high, low);
				        // },

				        /**
				         * Rotates this word n bits to the left.
				         *
				         * @param {number} n The number of bits to rotate.
				         *
				         * @return {X64Word} A new x64-Word object after rotating.
				         *
				         * @example
				         *
				         *     var rotated = x64Word.rotL(25);
				         */
				        // rotL: function (n) {
				            // return this.shiftL(n).or(this.shiftR(64 - n));
				        // },

				        /**
				         * Rotates this word n bits to the right.
				         *
				         * @param {number} n The number of bits to rotate.
				         *
				         * @return {X64Word} A new x64-Word object after rotating.
				         *
				         * @example
				         *
				         *     var rotated = x64Word.rotR(7);
				         */
				        // rotR: function (n) {
				            // return this.shiftR(n).or(this.shiftL(64 - n));
				        // },

				        /**
				         * Adds this word with the passed word.
				         *
				         * @param {X64Word} word The x64-Word to add with this word.
				         *
				         * @return {X64Word} A new x64-Word object after adding.
				         *
				         * @example
				         *
				         *     var added = x64Word.add(anotherX64Word);
				         */
				        // add: function (word) {
				            // var low = (this.low + word.low) | 0;
				            // var carry = (low >>> 0) < (this.low >>> 0) ? 1 : 0;
				            // var high = (this.high + word.high + carry) | 0;

				            // return X64Word.create(high, low);
				        // }
				    });

				    /**
				     * An array of 64-bit words.
				     *
				     * @property {Array} words The array of CryptoJS.x64.Word objects.
				     * @property {number} sigBytes The number of significant bytes in this word array.
				     */
				    C_x64.WordArray = Base.extend({
				        /**
				         * Initializes a newly created word array.
				         *
				         * @param {Array} words (Optional) An array of CryptoJS.x64.Word objects.
				         * @param {number} sigBytes (Optional) The number of significant bytes in the words.
				         *
				         * @example
				         *
				         *     var wordArray = CryptoJS.x64.WordArray.create();
				         *
				         *     var wordArray = CryptoJS.x64.WordArray.create([
				         *         CryptoJS.x64.Word.create(0x00010203, 0x04050607),
				         *         CryptoJS.x64.Word.create(0x18191a1b, 0x1c1d1e1f)
				         *     ]);
				         *
				         *     var wordArray = CryptoJS.x64.WordArray.create([
				         *         CryptoJS.x64.Word.create(0x00010203, 0x04050607),
				         *         CryptoJS.x64.Word.create(0x18191a1b, 0x1c1d1e1f)
				         *     ], 10);
				         */
				        init: function (words, sigBytes) {
				            words = this.words = words || [];

				            if (sigBytes != undefined$1) {
				                this.sigBytes = sigBytes;
				            } else {
				                this.sigBytes = words.length * 8;
				            }
				        },

				        /**
				         * Converts this 64-bit word array to a 32-bit word array.
				         *
				         * @return {CryptoJS.lib.WordArray} This word array's data as a 32-bit word array.
				         *
				         * @example
				         *
				         *     var x32WordArray = x64WordArray.toX32();
				         */
				        toX32: function () {
				            // Shortcuts
				            var x64Words = this.words;
				            var x64WordsLength = x64Words.length;

				            // Convert
				            var x32Words = [];
				            for (var i = 0; i < x64WordsLength; i++) {
				                var x64Word = x64Words[i];
				                x32Words.push(x64Word.high);
				                x32Words.push(x64Word.low);
				            }

				            return X32WordArray.create(x32Words, this.sigBytes);
				        },

				        /**
				         * Creates a copy of this word array.
				         *
				         * @return {X64WordArray} The clone.
				         *
				         * @example
				         *
				         *     var clone = x64WordArray.clone();
				         */
				        clone: function () {
				            var clone = Base.clone.call(this);

				            // Clone "words" array
				            var words = clone.words = this.words.slice(0);

				            // Clone each X64Word object
				            var wordsLength = words.length;
				            for (var i = 0; i < wordsLength; i++) {
				                words[i] = words[i].clone();
				            }

				            return clone;
				        }
				    });
				}());


				return CryptoJS;

			}));
		} (x64Core));
		return x64Core.exports;
	}

	var libTypedarrays = {exports: {}};

	var hasRequiredLibTypedarrays;

	function requireLibTypedarrays () {
		if (hasRequiredLibTypedarrays) return libTypedarrays.exports;
		hasRequiredLibTypedarrays = 1;
		(function (module, exports) {
	(function (root, factory) {
				{
					// CommonJS
					module.exports = factory(requireCore());
				}
			}(commonjsGlobal, function (CryptoJS) {

				(function () {
				    // Check if typed arrays are supported
				    if (typeof ArrayBuffer != 'function') {
				        return;
				    }

				    // Shortcuts
				    var C = CryptoJS;
				    var C_lib = C.lib;
				    var WordArray = C_lib.WordArray;

				    // Reference original init
				    var superInit = WordArray.init;

				    // Augment WordArray.init to handle typed arrays
				    var subInit = WordArray.init = function (typedArray) {
				        // Convert buffers to uint8
				        if (typedArray instanceof ArrayBuffer) {
				            typedArray = new Uint8Array(typedArray);
				        }

				        // Convert other array views to uint8
				        if (
				            typedArray instanceof Int8Array ||
				            (typeof Uint8ClampedArray !== "undefined" && typedArray instanceof Uint8ClampedArray) ||
				            typedArray instanceof Int16Array ||
				            typedArray instanceof Uint16Array ||
				            typedArray instanceof Int32Array ||
				            typedArray instanceof Uint32Array ||
				            typedArray instanceof Float32Array ||
				            typedArray instanceof Float64Array
				        ) {
				            typedArray = new Uint8Array(typedArray.buffer, typedArray.byteOffset, typedArray.byteLength);
				        }

				        // Handle Uint8Array
				        if (typedArray instanceof Uint8Array) {
				            // Shortcut
				            var typedArrayByteLength = typedArray.byteLength;

				            // Extract bytes
				            var words = [];
				            for (var i = 0; i < typedArrayByteLength; i++) {
				                words[i >>> 2] |= typedArray[i] << (24 - (i % 4) * 8);
				            }

				            // Initialize this word array
				            superInit.call(this, words, typedArrayByteLength);
				        } else {
				            // Else call normal init
				            superInit.apply(this, arguments);
				        }
				    };

				    subInit.prototype = WordArray;
				}());


				return CryptoJS.lib.WordArray;

			}));
		} (libTypedarrays));
		return libTypedarrays.exports;
	}

	var encUtf16 = {exports: {}};

	var hasRequiredEncUtf16;

	function requireEncUtf16 () {
		if (hasRequiredEncUtf16) return encUtf16.exports;
		hasRequiredEncUtf16 = 1;
		(function (module, exports) {
	(function (root, factory) {
				{
					// CommonJS
					module.exports = factory(requireCore());
				}
			}(commonjsGlobal, function (CryptoJS) {

				(function () {
				    // Shortcuts
				    var C = CryptoJS;
				    var C_lib = C.lib;
				    var WordArray = C_lib.WordArray;
				    var C_enc = C.enc;

				    /**
				     * UTF-16 BE encoding strategy.
				     */
				    C_enc.Utf16 = C_enc.Utf16BE = {
				        /**
				         * Converts a word array to a UTF-16 BE string.
				         *
				         * @param {WordArray} wordArray The word array.
				         *
				         * @return {string} The UTF-16 BE string.
				         *
				         * @static
				         *
				         * @example
				         *
				         *     var utf16String = CryptoJS.enc.Utf16.stringify(wordArray);
				         */
				        stringify: function (wordArray) {
				            // Shortcuts
				            var words = wordArray.words;
				            var sigBytes = wordArray.sigBytes;

				            // Convert
				            var utf16Chars = [];
				            for (var i = 0; i < sigBytes; i += 2) {
				                var codePoint = (words[i >>> 2] >>> (16 - (i % 4) * 8)) & 0xffff;
				                utf16Chars.push(String.fromCharCode(codePoint));
				            }

				            return utf16Chars.join('');
				        },

				        /**
				         * Converts a UTF-16 BE string to a word array.
				         *
				         * @param {string} utf16Str The UTF-16 BE string.
				         *
				         * @return {WordArray} The word array.
				         *
				         * @static
				         *
				         * @example
				         *
				         *     var wordArray = CryptoJS.enc.Utf16.parse(utf16String);
				         */
				        parse: function (utf16Str) {
				            // Shortcut
				            var utf16StrLength = utf16Str.length;

				            // Convert
				            var words = [];
				            for (var i = 0; i < utf16StrLength; i++) {
				                words[i >>> 1] |= utf16Str.charCodeAt(i) << (16 - (i % 2) * 16);
				            }

				            return WordArray.create(words, utf16StrLength * 2);
				        }
				    };

				    /**
				     * UTF-16 LE encoding strategy.
				     */
				    C_enc.Utf16LE = {
				        /**
				         * Converts a word array to a UTF-16 LE string.
				         *
				         * @param {WordArray} wordArray The word array.
				         *
				         * @return {string} The UTF-16 LE string.
				         *
				         * @static
				         *
				         * @example
				         *
				         *     var utf16Str = CryptoJS.enc.Utf16LE.stringify(wordArray);
				         */
				        stringify: function (wordArray) {
				            // Shortcuts
				            var words = wordArray.words;
				            var sigBytes = wordArray.sigBytes;

				            // Convert
				            var utf16Chars = [];
				            for (var i = 0; i < sigBytes; i += 2) {
				                var codePoint = swapEndian((words[i >>> 2] >>> (16 - (i % 4) * 8)) & 0xffff);
				                utf16Chars.push(String.fromCharCode(codePoint));
				            }

				            return utf16Chars.join('');
				        },

				        /**
				         * Converts a UTF-16 LE string to a word array.
				         *
				         * @param {string} utf16Str The UTF-16 LE string.
				         *
				         * @return {WordArray} The word array.
				         *
				         * @static
				         *
				         * @example
				         *
				         *     var wordArray = CryptoJS.enc.Utf16LE.parse(utf16Str);
				         */
				        parse: function (utf16Str) {
				            // Shortcut
				            var utf16StrLength = utf16Str.length;

				            // Convert
				            var words = [];
				            for (var i = 0; i < utf16StrLength; i++) {
				                words[i >>> 1] |= swapEndian(utf16Str.charCodeAt(i) << (16 - (i % 2) * 16));
				            }

				            return WordArray.create(words, utf16StrLength * 2);
				        }
				    };

				    function swapEndian(word) {
				        return ((word << 8) & 0xff00ff00) | ((word >>> 8) & 0x00ff00ff);
				    }
				}());


				return CryptoJS.enc.Utf16;

			}));
		} (encUtf16));
		return encUtf16.exports;
	}

	var encBase64 = {exports: {}};

	var hasRequiredEncBase64;

	function requireEncBase64 () {
		if (hasRequiredEncBase64) return encBase64.exports;
		hasRequiredEncBase64 = 1;
		(function (module, exports) {
	(function (root, factory) {
				{
					// CommonJS
					module.exports = factory(requireCore());
				}
			}(commonjsGlobal, function (CryptoJS) {

				(function () {
				    // Shortcuts
				    var C = CryptoJS;
				    var C_lib = C.lib;
				    var WordArray = C_lib.WordArray;
				    var C_enc = C.enc;

				    /**
				     * Base64 encoding strategy.
				     */
				    C_enc.Base64 = {
				        /**
				         * Converts a word array to a Base64 string.
				         *
				         * @param {WordArray} wordArray The word array.
				         *
				         * @return {string} The Base64 string.
				         *
				         * @static
				         *
				         * @example
				         *
				         *     var base64String = CryptoJS.enc.Base64.stringify(wordArray);
				         */
				        stringify: function (wordArray) {
				            // Shortcuts
				            var words = wordArray.words;
				            var sigBytes = wordArray.sigBytes;
				            var map = this._map;

				            // Clamp excess bits
				            wordArray.clamp();

				            // Convert
				            var base64Chars = [];
				            for (var i = 0; i < sigBytes; i += 3) {
				                var byte1 = (words[i >>> 2]       >>> (24 - (i % 4) * 8))       & 0xff;
				                var byte2 = (words[(i + 1) >>> 2] >>> (24 - ((i + 1) % 4) * 8)) & 0xff;
				                var byte3 = (words[(i + 2) >>> 2] >>> (24 - ((i + 2) % 4) * 8)) & 0xff;

				                var triplet = (byte1 << 16) | (byte2 << 8) | byte3;

				                for (var j = 0; (j < 4) && (i + j * 0.75 < sigBytes); j++) {
				                    base64Chars.push(map.charAt((triplet >>> (6 * (3 - j))) & 0x3f));
				                }
				            }

				            // Add padding
				            var paddingChar = map.charAt(64);
				            if (paddingChar) {
				                while (base64Chars.length % 4) {
				                    base64Chars.push(paddingChar);
				                }
				            }

				            return base64Chars.join('');
				        },

				        /**
				         * Converts a Base64 string to a word array.
				         *
				         * @param {string} base64Str The Base64 string.
				         *
				         * @return {WordArray} The word array.
				         *
				         * @static
				         *
				         * @example
				         *
				         *     var wordArray = CryptoJS.enc.Base64.parse(base64String);
				         */
				        parse: function (base64Str) {
				            // Shortcuts
				            var base64StrLength = base64Str.length;
				            var map = this._map;
				            var reverseMap = this._reverseMap;

				            if (!reverseMap) {
				                    reverseMap = this._reverseMap = [];
				                    for (var j = 0; j < map.length; j++) {
				                        reverseMap[map.charCodeAt(j)] = j;
				                    }
				            }

				            // Ignore padding
				            var paddingChar = map.charAt(64);
				            if (paddingChar) {
				                var paddingIndex = base64Str.indexOf(paddingChar);
				                if (paddingIndex !== -1) {
				                    base64StrLength = paddingIndex;
				                }
				            }

				            // Convert
				            return parseLoop(base64Str, base64StrLength, reverseMap);

				        },

				        _map: 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/='
				    };

				    function parseLoop(base64Str, base64StrLength, reverseMap) {
				      var words = [];
				      var nBytes = 0;
				      for (var i = 0; i < base64StrLength; i++) {
				          if (i % 4) {
				              var bits1 = reverseMap[base64Str.charCodeAt(i - 1)] << ((i % 4) * 2);
				              var bits2 = reverseMap[base64Str.charCodeAt(i)] >>> (6 - (i % 4) * 2);
				              words[nBytes >>> 2] |= (bits1 | bits2) << (24 - (nBytes % 4) * 8);
				              nBytes++;
				          }
				      }
				      return WordArray.create(words, nBytes);
				    }
				}());


				return CryptoJS.enc.Base64;

			}));
		} (encBase64));
		return encBase64.exports;
	}

	var md5 = {exports: {}};

	var hasRequiredMd5;

	function requireMd5 () {
		if (hasRequiredMd5) return md5.exports;
		hasRequiredMd5 = 1;
		(function (module, exports) {
	(function (root, factory) {
				{
					// CommonJS
					module.exports = factory(requireCore());
				}
			}(commonjsGlobal, function (CryptoJS) {

				(function (Math) {
				    // Shortcuts
				    var C = CryptoJS;
				    var C_lib = C.lib;
				    var WordArray = C_lib.WordArray;
				    var Hasher = C_lib.Hasher;
				    var C_algo = C.algo;

				    // Constants table
				    var T = [];

				    // Compute constants
				    (function () {
				        for (var i = 0; i < 64; i++) {
				            T[i] = (Math.abs(Math.sin(i + 1)) * 0x100000000) | 0;
				        }
				    }());

				    /**
				     * MD5 hash algorithm.
				     */
				    var MD5 = C_algo.MD5 = Hasher.extend({
				        _doReset: function () {
				            this._hash = new WordArray.init([
				                0x67452301, 0xefcdab89,
				                0x98badcfe, 0x10325476
				            ]);
				        },

				        _doProcessBlock: function (M, offset) {
				            // Swap endian
				            for (var i = 0; i < 16; i++) {
				                // Shortcuts
				                var offset_i = offset + i;
				                var M_offset_i = M[offset_i];

				                M[offset_i] = (
				                    (((M_offset_i << 8)  | (M_offset_i >>> 24)) & 0x00ff00ff) |
				                    (((M_offset_i << 24) | (M_offset_i >>> 8))  & 0xff00ff00)
				                );
				            }

				            // Shortcuts
				            var H = this._hash.words;

				            var M_offset_0  = M[offset + 0];
				            var M_offset_1  = M[offset + 1];
				            var M_offset_2  = M[offset + 2];
				            var M_offset_3  = M[offset + 3];
				            var M_offset_4  = M[offset + 4];
				            var M_offset_5  = M[offset + 5];
				            var M_offset_6  = M[offset + 6];
				            var M_offset_7  = M[offset + 7];
				            var M_offset_8  = M[offset + 8];
				            var M_offset_9  = M[offset + 9];
				            var M_offset_10 = M[offset + 10];
				            var M_offset_11 = M[offset + 11];
				            var M_offset_12 = M[offset + 12];
				            var M_offset_13 = M[offset + 13];
				            var M_offset_14 = M[offset + 14];
				            var M_offset_15 = M[offset + 15];

				            // Working varialbes
				            var a = H[0];
				            var b = H[1];
				            var c = H[2];
				            var d = H[3];

				            // Computation
				            a = FF(a, b, c, d, M_offset_0,  7,  T[0]);
				            d = FF(d, a, b, c, M_offset_1,  12, T[1]);
				            c = FF(c, d, a, b, M_offset_2,  17, T[2]);
				            b = FF(b, c, d, a, M_offset_3,  22, T[3]);
				            a = FF(a, b, c, d, M_offset_4,  7,  T[4]);
				            d = FF(d, a, b, c, M_offset_5,  12, T[5]);
				            c = FF(c, d, a, b, M_offset_6,  17, T[6]);
				            b = FF(b, c, d, a, M_offset_7,  22, T[7]);
				            a = FF(a, b, c, d, M_offset_8,  7,  T[8]);
				            d = FF(d, a, b, c, M_offset_9,  12, T[9]);
				            c = FF(c, d, a, b, M_offset_10, 17, T[10]);
				            b = FF(b, c, d, a, M_offset_11, 22, T[11]);
				            a = FF(a, b, c, d, M_offset_12, 7,  T[12]);
				            d = FF(d, a, b, c, M_offset_13, 12, T[13]);
				            c = FF(c, d, a, b, M_offset_14, 17, T[14]);
				            b = FF(b, c, d, a, M_offset_15, 22, T[15]);

				            a = GG(a, b, c, d, M_offset_1,  5,  T[16]);
				            d = GG(d, a, b, c, M_offset_6,  9,  T[17]);
				            c = GG(c, d, a, b, M_offset_11, 14, T[18]);
				            b = GG(b, c, d, a, M_offset_0,  20, T[19]);
				            a = GG(a, b, c, d, M_offset_5,  5,  T[20]);
				            d = GG(d, a, b, c, M_offset_10, 9,  T[21]);
				            c = GG(c, d, a, b, M_offset_15, 14, T[22]);
				            b = GG(b, c, d, a, M_offset_4,  20, T[23]);
				            a = GG(a, b, c, d, M_offset_9,  5,  T[24]);
				            d = GG(d, a, b, c, M_offset_14, 9,  T[25]);
				            c = GG(c, d, a, b, M_offset_3,  14, T[26]);
				            b = GG(b, c, d, a, M_offset_8,  20, T[27]);
				            a = GG(a, b, c, d, M_offset_13, 5,  T[28]);
				            d = GG(d, a, b, c, M_offset_2,  9,  T[29]);
				            c = GG(c, d, a, b, M_offset_7,  14, T[30]);
				            b = GG(b, c, d, a, M_offset_12, 20, T[31]);

				            a = HH(a, b, c, d, M_offset_5,  4,  T[32]);
				            d = HH(d, a, b, c, M_offset_8,  11, T[33]);
				            c = HH(c, d, a, b, M_offset_11, 16, T[34]);
				            b = HH(b, c, d, a, M_offset_14, 23, T[35]);
				            a = HH(a, b, c, d, M_offset_1,  4,  T[36]);
				            d = HH(d, a, b, c, M_offset_4,  11, T[37]);
				            c = HH(c, d, a, b, M_offset_7,  16, T[38]);
				            b = HH(b, c, d, a, M_offset_10, 23, T[39]);
				            a = HH(a, b, c, d, M_offset_13, 4,  T[40]);
				            d = HH(d, a, b, c, M_offset_0,  11, T[41]);
				            c = HH(c, d, a, b, M_offset_3,  16, T[42]);
				            b = HH(b, c, d, a, M_offset_6,  23, T[43]);
				            a = HH(a, b, c, d, M_offset_9,  4,  T[44]);
				            d = HH(d, a, b, c, M_offset_12, 11, T[45]);
				            c = HH(c, d, a, b, M_offset_15, 16, T[46]);
				            b = HH(b, c, d, a, M_offset_2,  23, T[47]);

				            a = II(a, b, c, d, M_offset_0,  6,  T[48]);
				            d = II(d, a, b, c, M_offset_7,  10, T[49]);
				            c = II(c, d, a, b, M_offset_14, 15, T[50]);
				            b = II(b, c, d, a, M_offset_5,  21, T[51]);
				            a = II(a, b, c, d, M_offset_12, 6,  T[52]);
				            d = II(d, a, b, c, M_offset_3,  10, T[53]);
				            c = II(c, d, a, b, M_offset_10, 15, T[54]);
				            b = II(b, c, d, a, M_offset_1,  21, T[55]);
				            a = II(a, b, c, d, M_offset_8,  6,  T[56]);
				            d = II(d, a, b, c, M_offset_15, 10, T[57]);
				            c = II(c, d, a, b, M_offset_6,  15, T[58]);
				            b = II(b, c, d, a, M_offset_13, 21, T[59]);
				            a = II(a, b, c, d, M_offset_4,  6,  T[60]);
				            d = II(d, a, b, c, M_offset_11, 10, T[61]);
				            c = II(c, d, a, b, M_offset_2,  15, T[62]);
				            b = II(b, c, d, a, M_offset_9,  21, T[63]);

				            // Intermediate hash value
				            H[0] = (H[0] + a) | 0;
				            H[1] = (H[1] + b) | 0;
				            H[2] = (H[2] + c) | 0;
				            H[3] = (H[3] + d) | 0;
				        },

				        _doFinalize: function () {
				            // Shortcuts
				            var data = this._data;
				            var dataWords = data.words;

				            var nBitsTotal = this._nDataBytes * 8;
				            var nBitsLeft = data.sigBytes * 8;

				            // Add padding
				            dataWords[nBitsLeft >>> 5] |= 0x80 << (24 - nBitsLeft % 32);

				            var nBitsTotalH = Math.floor(nBitsTotal / 0x100000000);
				            var nBitsTotalL = nBitsTotal;
				            dataWords[(((nBitsLeft + 64) >>> 9) << 4) + 15] = (
				                (((nBitsTotalH << 8)  | (nBitsTotalH >>> 24)) & 0x00ff00ff) |
				                (((nBitsTotalH << 24) | (nBitsTotalH >>> 8))  & 0xff00ff00)
				            );
				            dataWords[(((nBitsLeft + 64) >>> 9) << 4) + 14] = (
				                (((nBitsTotalL << 8)  | (nBitsTotalL >>> 24)) & 0x00ff00ff) |
				                (((nBitsTotalL << 24) | (nBitsTotalL >>> 8))  & 0xff00ff00)
				            );

				            data.sigBytes = (dataWords.length + 1) * 4;

				            // Hash final blocks
				            this._process();

				            // Shortcuts
				            var hash = this._hash;
				            var H = hash.words;

				            // Swap endian
				            for (var i = 0; i < 4; i++) {
				                // Shortcut
				                var H_i = H[i];

				                H[i] = (((H_i << 8)  | (H_i >>> 24)) & 0x00ff00ff) |
				                       (((H_i << 24) | (H_i >>> 8))  & 0xff00ff00);
				            }

				            // Return final computed hash
				            return hash;
				        },

				        clone: function () {
				            var clone = Hasher.clone.call(this);
				            clone._hash = this._hash.clone();

				            return clone;
				        }
				    });

				    function FF(a, b, c, d, x, s, t) {
				        var n = a + ((b & c) | (~b & d)) + x + t;
				        return ((n << s) | (n >>> (32 - s))) + b;
				    }

				    function GG(a, b, c, d, x, s, t) {
				        var n = a + ((b & d) | (c & ~d)) + x + t;
				        return ((n << s) | (n >>> (32 - s))) + b;
				    }

				    function HH(a, b, c, d, x, s, t) {
				        var n = a + (b ^ c ^ d) + x + t;
				        return ((n << s) | (n >>> (32 - s))) + b;
				    }

				    function II(a, b, c, d, x, s, t) {
				        var n = a + (c ^ (b | ~d)) + x + t;
				        return ((n << s) | (n >>> (32 - s))) + b;
				    }

				    /**
				     * Shortcut function to the hasher's object interface.
				     *
				     * @param {WordArray|string} message The message to hash.
				     *
				     * @return {WordArray} The hash.
				     *
				     * @static
				     *
				     * @example
				     *
				     *     var hash = CryptoJS.MD5('message');
				     *     var hash = CryptoJS.MD5(wordArray);
				     */
				    C.MD5 = Hasher._createHelper(MD5);

				    /**
				     * Shortcut function to the HMAC's object interface.
				     *
				     * @param {WordArray|string} message The message to hash.
				     * @param {WordArray|string} key The secret key.
				     *
				     * @return {WordArray} The HMAC.
				     *
				     * @static
				     *
				     * @example
				     *
				     *     var hmac = CryptoJS.HmacMD5(message, key);
				     */
				    C.HmacMD5 = Hasher._createHmacHelper(MD5);
				}(Math));


				return CryptoJS.MD5;

			}));
		} (md5));
		return md5.exports;
	}

	var sha1 = {exports: {}};

	var hasRequiredSha1;

	function requireSha1 () {
		if (hasRequiredSha1) return sha1.exports;
		hasRequiredSha1 = 1;
		(function (module, exports) {
	(function (root, factory) {
				{
					// CommonJS
					module.exports = factory(requireCore());
				}
			}(commonjsGlobal, function (CryptoJS) {

				(function () {
				    // Shortcuts
				    var C = CryptoJS;
				    var C_lib = C.lib;
				    var WordArray = C_lib.WordArray;
				    var Hasher = C_lib.Hasher;
				    var C_algo = C.algo;

				    // Reusable object
				    var W = [];

				    /**
				     * SHA-1 hash algorithm.
				     */
				    var SHA1 = C_algo.SHA1 = Hasher.extend({
				        _doReset: function () {
				            this._hash = new WordArray.init([
				                0x67452301, 0xefcdab89,
				                0x98badcfe, 0x10325476,
				                0xc3d2e1f0
				            ]);
				        },

				        _doProcessBlock: function (M, offset) {
				            // Shortcut
				            var H = this._hash.words;

				            // Working variables
				            var a = H[0];
				            var b = H[1];
				            var c = H[2];
				            var d = H[3];
				            var e = H[4];

				            // Computation
				            for (var i = 0; i < 80; i++) {
				                if (i < 16) {
				                    W[i] = M[offset + i] | 0;
				                } else {
				                    var n = W[i - 3] ^ W[i - 8] ^ W[i - 14] ^ W[i - 16];
				                    W[i] = (n << 1) | (n >>> 31);
				                }

				                var t = ((a << 5) | (a >>> 27)) + e + W[i];
				                if (i < 20) {
				                    t += ((b & c) | (~b & d)) + 0x5a827999;
				                } else if (i < 40) {
				                    t += (b ^ c ^ d) + 0x6ed9eba1;
				                } else if (i < 60) {
				                    t += ((b & c) | (b & d) | (c & d)) - 0x70e44324;
				                } else /* if (i < 80) */ {
				                    t += (b ^ c ^ d) - 0x359d3e2a;
				                }

				                e = d;
				                d = c;
				                c = (b << 30) | (b >>> 2);
				                b = a;
				                a = t;
				            }

				            // Intermediate hash value
				            H[0] = (H[0] + a) | 0;
				            H[1] = (H[1] + b) | 0;
				            H[2] = (H[2] + c) | 0;
				            H[3] = (H[3] + d) | 0;
				            H[4] = (H[4] + e) | 0;
				        },

				        _doFinalize: function () {
				            // Shortcuts
				            var data = this._data;
				            var dataWords = data.words;

				            var nBitsTotal = this._nDataBytes * 8;
				            var nBitsLeft = data.sigBytes * 8;

				            // Add padding
				            dataWords[nBitsLeft >>> 5] |= 0x80 << (24 - nBitsLeft % 32);
				            dataWords[(((nBitsLeft + 64) >>> 9) << 4) + 14] = Math.floor(nBitsTotal / 0x100000000);
				            dataWords[(((nBitsLeft + 64) >>> 9) << 4) + 15] = nBitsTotal;
				            data.sigBytes = dataWords.length * 4;

				            // Hash final blocks
				            this._process();

				            // Return final computed hash
				            return this._hash;
				        },

				        clone: function () {
				            var clone = Hasher.clone.call(this);
				            clone._hash = this._hash.clone();

				            return clone;
				        }
				    });

				    /**
				     * Shortcut function to the hasher's object interface.
				     *
				     * @param {WordArray|string} message The message to hash.
				     *
				     * @return {WordArray} The hash.
				     *
				     * @static
				     *
				     * @example
				     *
				     *     var hash = CryptoJS.SHA1('message');
				     *     var hash = CryptoJS.SHA1(wordArray);
				     */
				    C.SHA1 = Hasher._createHelper(SHA1);

				    /**
				     * Shortcut function to the HMAC's object interface.
				     *
				     * @param {WordArray|string} message The message to hash.
				     * @param {WordArray|string} key The secret key.
				     *
				     * @return {WordArray} The HMAC.
				     *
				     * @static
				     *
				     * @example
				     *
				     *     var hmac = CryptoJS.HmacSHA1(message, key);
				     */
				    C.HmacSHA1 = Hasher._createHmacHelper(SHA1);
				}());


				return CryptoJS.SHA1;

			}));
		} (sha1));
		return sha1.exports;
	}

	var sha256 = {exports: {}};

	var hasRequiredSha256;

	function requireSha256 () {
		if (hasRequiredSha256) return sha256.exports;
		hasRequiredSha256 = 1;
		(function (module, exports) {
	(function (root, factory) {
				{
					// CommonJS
					module.exports = factory(requireCore());
				}
			}(commonjsGlobal, function (CryptoJS) {

				(function (Math) {
				    // Shortcuts
				    var C = CryptoJS;
				    var C_lib = C.lib;
				    var WordArray = C_lib.WordArray;
				    var Hasher = C_lib.Hasher;
				    var C_algo = C.algo;

				    // Initialization and round constants tables
				    var H = [];
				    var K = [];

				    // Compute constants
				    (function () {
				        function isPrime(n) {
				            var sqrtN = Math.sqrt(n);
				            for (var factor = 2; factor <= sqrtN; factor++) {
				                if (!(n % factor)) {
				                    return false;
				                }
				            }

				            return true;
				        }

				        function getFractionalBits(n) {
				            return ((n - (n | 0)) * 0x100000000) | 0;
				        }

				        var n = 2;
				        var nPrime = 0;
				        while (nPrime < 64) {
				            if (isPrime(n)) {
				                if (nPrime < 8) {
				                    H[nPrime] = getFractionalBits(Math.pow(n, 1 / 2));
				                }
				                K[nPrime] = getFractionalBits(Math.pow(n, 1 / 3));

				                nPrime++;
				            }

				            n++;
				        }
				    }());

				    // Reusable object
				    var W = [];

				    /**
				     * SHA-256 hash algorithm.
				     */
				    var SHA256 = C_algo.SHA256 = Hasher.extend({
				        _doReset: function () {
				            this._hash = new WordArray.init(H.slice(0));
				        },

				        _doProcessBlock: function (M, offset) {
				            // Shortcut
				            var H = this._hash.words;

				            // Working variables
				            var a = H[0];
				            var b = H[1];
				            var c = H[2];
				            var d = H[3];
				            var e = H[4];
				            var f = H[5];
				            var g = H[6];
				            var h = H[7];

				            // Computation
				            for (var i = 0; i < 64; i++) {
				                if (i < 16) {
				                    W[i] = M[offset + i] | 0;
				                } else {
				                    var gamma0x = W[i - 15];
				                    var gamma0  = ((gamma0x << 25) | (gamma0x >>> 7))  ^
				                                  ((gamma0x << 14) | (gamma0x >>> 18)) ^
				                                   (gamma0x >>> 3);

				                    var gamma1x = W[i - 2];
				                    var gamma1  = ((gamma1x << 15) | (gamma1x >>> 17)) ^
				                                  ((gamma1x << 13) | (gamma1x >>> 19)) ^
				                                   (gamma1x >>> 10);

				                    W[i] = gamma0 + W[i - 7] + gamma1 + W[i - 16];
				                }

				                var ch  = (e & f) ^ (~e & g);
				                var maj = (a & b) ^ (a & c) ^ (b & c);

				                var sigma0 = ((a << 30) | (a >>> 2)) ^ ((a << 19) | (a >>> 13)) ^ ((a << 10) | (a >>> 22));
				                var sigma1 = ((e << 26) | (e >>> 6)) ^ ((e << 21) | (e >>> 11)) ^ ((e << 7)  | (e >>> 25));

				                var t1 = h + sigma1 + ch + K[i] + W[i];
				                var t2 = sigma0 + maj;

				                h = g;
				                g = f;
				                f = e;
				                e = (d + t1) | 0;
				                d = c;
				                c = b;
				                b = a;
				                a = (t1 + t2) | 0;
				            }

				            // Intermediate hash value
				            H[0] = (H[0] + a) | 0;
				            H[1] = (H[1] + b) | 0;
				            H[2] = (H[2] + c) | 0;
				            H[3] = (H[3] + d) | 0;
				            H[4] = (H[4] + e) | 0;
				            H[5] = (H[5] + f) | 0;
				            H[6] = (H[6] + g) | 0;
				            H[7] = (H[7] + h) | 0;
				        },

				        _doFinalize: function () {
				            // Shortcuts
				            var data = this._data;
				            var dataWords = data.words;

				            var nBitsTotal = this._nDataBytes * 8;
				            var nBitsLeft = data.sigBytes * 8;

				            // Add padding
				            dataWords[nBitsLeft >>> 5] |= 0x80 << (24 - nBitsLeft % 32);
				            dataWords[(((nBitsLeft + 64) >>> 9) << 4) + 14] = Math.floor(nBitsTotal / 0x100000000);
				            dataWords[(((nBitsLeft + 64) >>> 9) << 4) + 15] = nBitsTotal;
				            data.sigBytes = dataWords.length * 4;

				            // Hash final blocks
				            this._process();

				            // Return final computed hash
				            return this._hash;
				        },

				        clone: function () {
				            var clone = Hasher.clone.call(this);
				            clone._hash = this._hash.clone();

				            return clone;
				        }
				    });

				    /**
				     * Shortcut function to the hasher's object interface.
				     *
				     * @param {WordArray|string} message The message to hash.
				     *
				     * @return {WordArray} The hash.
				     *
				     * @static
				     *
				     * @example
				     *
				     *     var hash = CryptoJS.SHA256('message');
				     *     var hash = CryptoJS.SHA256(wordArray);
				     */
				    C.SHA256 = Hasher._createHelper(SHA256);

				    /**
				     * Shortcut function to the HMAC's object interface.
				     *
				     * @param {WordArray|string} message The message to hash.
				     * @param {WordArray|string} key The secret key.
				     *
				     * @return {WordArray} The HMAC.
				     *
				     * @static
				     *
				     * @example
				     *
				     *     var hmac = CryptoJS.HmacSHA256(message, key);
				     */
				    C.HmacSHA256 = Hasher._createHmacHelper(SHA256);
				}(Math));


				return CryptoJS.SHA256;

			}));
		} (sha256));
		return sha256.exports;
	}

	var sha224 = {exports: {}};

	var hasRequiredSha224;

	function requireSha224 () {
		if (hasRequiredSha224) return sha224.exports;
		hasRequiredSha224 = 1;
		(function (module, exports) {
	(function (root, factory, undef) {
				{
					// CommonJS
					module.exports = factory(requireCore(), requireSha256());
				}
			}(commonjsGlobal, function (CryptoJS) {

				(function () {
				    // Shortcuts
				    var C = CryptoJS;
				    var C_lib = C.lib;
				    var WordArray = C_lib.WordArray;
				    var C_algo = C.algo;
				    var SHA256 = C_algo.SHA256;

				    /**
				     * SHA-224 hash algorithm.
				     */
				    var SHA224 = C_algo.SHA224 = SHA256.extend({
				        _doReset: function () {
				            this._hash = new WordArray.init([
				                0xc1059ed8, 0x367cd507, 0x3070dd17, 0xf70e5939,
				                0xffc00b31, 0x68581511, 0x64f98fa7, 0xbefa4fa4
				            ]);
				        },

				        _doFinalize: function () {
				            var hash = SHA256._doFinalize.call(this);

				            hash.sigBytes -= 4;

				            return hash;
				        }
				    });

				    /**
				     * Shortcut function to the hasher's object interface.
				     *
				     * @param {WordArray|string} message The message to hash.
				     *
				     * @return {WordArray} The hash.
				     *
				     * @static
				     *
				     * @example
				     *
				     *     var hash = CryptoJS.SHA224('message');
				     *     var hash = CryptoJS.SHA224(wordArray);
				     */
				    C.SHA224 = SHA256._createHelper(SHA224);

				    /**
				     * Shortcut function to the HMAC's object interface.
				     *
				     * @param {WordArray|string} message The message to hash.
				     * @param {WordArray|string} key The secret key.
				     *
				     * @return {WordArray} The HMAC.
				     *
				     * @static
				     *
				     * @example
				     *
				     *     var hmac = CryptoJS.HmacSHA224(message, key);
				     */
				    C.HmacSHA224 = SHA256._createHmacHelper(SHA224);
				}());


				return CryptoJS.SHA224;

			}));
		} (sha224));
		return sha224.exports;
	}

	var sha512 = {exports: {}};

	var hasRequiredSha512;

	function requireSha512 () {
		if (hasRequiredSha512) return sha512.exports;
		hasRequiredSha512 = 1;
		(function (module, exports) {
	(function (root, factory, undef) {
				{
					// CommonJS
					module.exports = factory(requireCore(), requireX64Core());
				}
			}(commonjsGlobal, function (CryptoJS) {

				(function () {
				    // Shortcuts
				    var C = CryptoJS;
				    var C_lib = C.lib;
				    var Hasher = C_lib.Hasher;
				    var C_x64 = C.x64;
				    var X64Word = C_x64.Word;
				    var X64WordArray = C_x64.WordArray;
				    var C_algo = C.algo;

				    function X64Word_create() {
				        return X64Word.create.apply(X64Word, arguments);
				    }

				    // Constants
				    var K = [
				        X64Word_create(0x428a2f98, 0xd728ae22), X64Word_create(0x71374491, 0x23ef65cd),
				        X64Word_create(0xb5c0fbcf, 0xec4d3b2f), X64Word_create(0xe9b5dba5, 0x8189dbbc),
				        X64Word_create(0x3956c25b, 0xf348b538), X64Word_create(0x59f111f1, 0xb605d019),
				        X64Word_create(0x923f82a4, 0xaf194f9b), X64Word_create(0xab1c5ed5, 0xda6d8118),
				        X64Word_create(0xd807aa98, 0xa3030242), X64Word_create(0x12835b01, 0x45706fbe),
				        X64Word_create(0x243185be, 0x4ee4b28c), X64Word_create(0x550c7dc3, 0xd5ffb4e2),
				        X64Word_create(0x72be5d74, 0xf27b896f), X64Word_create(0x80deb1fe, 0x3b1696b1),
				        X64Word_create(0x9bdc06a7, 0x25c71235), X64Word_create(0xc19bf174, 0xcf692694),
				        X64Word_create(0xe49b69c1, 0x9ef14ad2), X64Word_create(0xefbe4786, 0x384f25e3),
				        X64Word_create(0x0fc19dc6, 0x8b8cd5b5), X64Word_create(0x240ca1cc, 0x77ac9c65),
				        X64Word_create(0x2de92c6f, 0x592b0275), X64Word_create(0x4a7484aa, 0x6ea6e483),
				        X64Word_create(0x5cb0a9dc, 0xbd41fbd4), X64Word_create(0x76f988da, 0x831153b5),
				        X64Word_create(0x983e5152, 0xee66dfab), X64Word_create(0xa831c66d, 0x2db43210),
				        X64Word_create(0xb00327c8, 0x98fb213f), X64Word_create(0xbf597fc7, 0xbeef0ee4),
				        X64Word_create(0xc6e00bf3, 0x3da88fc2), X64Word_create(0xd5a79147, 0x930aa725),
				        X64Word_create(0x06ca6351, 0xe003826f), X64Word_create(0x14292967, 0x0a0e6e70),
				        X64Word_create(0x27b70a85, 0x46d22ffc), X64Word_create(0x2e1b2138, 0x5c26c926),
				        X64Word_create(0x4d2c6dfc, 0x5ac42aed), X64Word_create(0x53380d13, 0x9d95b3df),
				        X64Word_create(0x650a7354, 0x8baf63de), X64Word_create(0x766a0abb, 0x3c77b2a8),
				        X64Word_create(0x81c2c92e, 0x47edaee6), X64Word_create(0x92722c85, 0x1482353b),
				        X64Word_create(0xa2bfe8a1, 0x4cf10364), X64Word_create(0xa81a664b, 0xbc423001),
				        X64Word_create(0xc24b8b70, 0xd0f89791), X64Word_create(0xc76c51a3, 0x0654be30),
				        X64Word_create(0xd192e819, 0xd6ef5218), X64Word_create(0xd6990624, 0x5565a910),
				        X64Word_create(0xf40e3585, 0x5771202a), X64Word_create(0x106aa070, 0x32bbd1b8),
				        X64Word_create(0x19a4c116, 0xb8d2d0c8), X64Word_create(0x1e376c08, 0x5141ab53),
				        X64Word_create(0x2748774c, 0xdf8eeb99), X64Word_create(0x34b0bcb5, 0xe19b48a8),
				        X64Word_create(0x391c0cb3, 0xc5c95a63), X64Word_create(0x4ed8aa4a, 0xe3418acb),
				        X64Word_create(0x5b9cca4f, 0x7763e373), X64Word_create(0x682e6ff3, 0xd6b2b8a3),
				        X64Word_create(0x748f82ee, 0x5defb2fc), X64Word_create(0x78a5636f, 0x43172f60),
				        X64Word_create(0x84c87814, 0xa1f0ab72), X64Word_create(0x8cc70208, 0x1a6439ec),
				        X64Word_create(0x90befffa, 0x23631e28), X64Word_create(0xa4506ceb, 0xde82bde9),
				        X64Word_create(0xbef9a3f7, 0xb2c67915), X64Word_create(0xc67178f2, 0xe372532b),
				        X64Word_create(0xca273ece, 0xea26619c), X64Word_create(0xd186b8c7, 0x21c0c207),
				        X64Word_create(0xeada7dd6, 0xcde0eb1e), X64Word_create(0xf57d4f7f, 0xee6ed178),
				        X64Word_create(0x06f067aa, 0x72176fba), X64Word_create(0x0a637dc5, 0xa2c898a6),
				        X64Word_create(0x113f9804, 0xbef90dae), X64Word_create(0x1b710b35, 0x131c471b),
				        X64Word_create(0x28db77f5, 0x23047d84), X64Word_create(0x32caab7b, 0x40c72493),
				        X64Word_create(0x3c9ebe0a, 0x15c9bebc), X64Word_create(0x431d67c4, 0x9c100d4c),
				        X64Word_create(0x4cc5d4be, 0xcb3e42b6), X64Word_create(0x597f299c, 0xfc657e2a),
				        X64Word_create(0x5fcb6fab, 0x3ad6faec), X64Word_create(0x6c44198c, 0x4a475817)
				    ];

				    // Reusable objects
				    var W = [];
				    (function () {
				        for (var i = 0; i < 80; i++) {
				            W[i] = X64Word_create();
				        }
				    }());

				    /**
				     * SHA-512 hash algorithm.
				     */
				    var SHA512 = C_algo.SHA512 = Hasher.extend({
				        _doReset: function () {
				            this._hash = new X64WordArray.init([
				                new X64Word.init(0x6a09e667, 0xf3bcc908), new X64Word.init(0xbb67ae85, 0x84caa73b),
				                new X64Word.init(0x3c6ef372, 0xfe94f82b), new X64Word.init(0xa54ff53a, 0x5f1d36f1),
				                new X64Word.init(0x510e527f, 0xade682d1), new X64Word.init(0x9b05688c, 0x2b3e6c1f),
				                new X64Word.init(0x1f83d9ab, 0xfb41bd6b), new X64Word.init(0x5be0cd19, 0x137e2179)
				            ]);
				        },

				        _doProcessBlock: function (M, offset) {
				            // Shortcuts
				            var H = this._hash.words;

				            var H0 = H[0];
				            var H1 = H[1];
				            var H2 = H[2];
				            var H3 = H[3];
				            var H4 = H[4];
				            var H5 = H[5];
				            var H6 = H[6];
				            var H7 = H[7];

				            var H0h = H0.high;
				            var H0l = H0.low;
				            var H1h = H1.high;
				            var H1l = H1.low;
				            var H2h = H2.high;
				            var H2l = H2.low;
				            var H3h = H3.high;
				            var H3l = H3.low;
				            var H4h = H4.high;
				            var H4l = H4.low;
				            var H5h = H5.high;
				            var H5l = H5.low;
				            var H6h = H6.high;
				            var H6l = H6.low;
				            var H7h = H7.high;
				            var H7l = H7.low;

				            // Working variables
				            var ah = H0h;
				            var al = H0l;
				            var bh = H1h;
				            var bl = H1l;
				            var ch = H2h;
				            var cl = H2l;
				            var dh = H3h;
				            var dl = H3l;
				            var eh = H4h;
				            var el = H4l;
				            var fh = H5h;
				            var fl = H5l;
				            var gh = H6h;
				            var gl = H6l;
				            var hh = H7h;
				            var hl = H7l;

				            // Rounds
				            for (var i = 0; i < 80; i++) {
				                // Shortcut
				                var Wi = W[i];

				                // Extend message
				                if (i < 16) {
				                    var Wih = Wi.high = M[offset + i * 2]     | 0;
				                    var Wil = Wi.low  = M[offset + i * 2 + 1] | 0;
				                } else {
				                    // Gamma0
				                    var gamma0x  = W[i - 15];
				                    var gamma0xh = gamma0x.high;
				                    var gamma0xl = gamma0x.low;
				                    var gamma0h  = ((gamma0xh >>> 1) | (gamma0xl << 31)) ^ ((gamma0xh >>> 8) | (gamma0xl << 24)) ^ (gamma0xh >>> 7);
				                    var gamma0l  = ((gamma0xl >>> 1) | (gamma0xh << 31)) ^ ((gamma0xl >>> 8) | (gamma0xh << 24)) ^ ((gamma0xl >>> 7) | (gamma0xh << 25));

				                    // Gamma1
				                    var gamma1x  = W[i - 2];
				                    var gamma1xh = gamma1x.high;
				                    var gamma1xl = gamma1x.low;
				                    var gamma1h  = ((gamma1xh >>> 19) | (gamma1xl << 13)) ^ ((gamma1xh << 3) | (gamma1xl >>> 29)) ^ (gamma1xh >>> 6);
				                    var gamma1l  = ((gamma1xl >>> 19) | (gamma1xh << 13)) ^ ((gamma1xl << 3) | (gamma1xh >>> 29)) ^ ((gamma1xl >>> 6) | (gamma1xh << 26));

				                    // W[i] = gamma0 + W[i - 7] + gamma1 + W[i - 16]
				                    var Wi7  = W[i - 7];
				                    var Wi7h = Wi7.high;
				                    var Wi7l = Wi7.low;

				                    var Wi16  = W[i - 16];
				                    var Wi16h = Wi16.high;
				                    var Wi16l = Wi16.low;

				                    var Wil = gamma0l + Wi7l;
				                    var Wih = gamma0h + Wi7h + ((Wil >>> 0) < (gamma0l >>> 0) ? 1 : 0);
				                    var Wil = Wil + gamma1l;
				                    var Wih = Wih + gamma1h + ((Wil >>> 0) < (gamma1l >>> 0) ? 1 : 0);
				                    var Wil = Wil + Wi16l;
				                    var Wih = Wih + Wi16h + ((Wil >>> 0) < (Wi16l >>> 0) ? 1 : 0);

				                    Wi.high = Wih;
				                    Wi.low  = Wil;
				                }

				                var chh  = (eh & fh) ^ (~eh & gh);
				                var chl  = (el & fl) ^ (~el & gl);
				                var majh = (ah & bh) ^ (ah & ch) ^ (bh & ch);
				                var majl = (al & bl) ^ (al & cl) ^ (bl & cl);

				                var sigma0h = ((ah >>> 28) | (al << 4))  ^ ((ah << 30)  | (al >>> 2)) ^ ((ah << 25) | (al >>> 7));
				                var sigma0l = ((al >>> 28) | (ah << 4))  ^ ((al << 30)  | (ah >>> 2)) ^ ((al << 25) | (ah >>> 7));
				                var sigma1h = ((eh >>> 14) | (el << 18)) ^ ((eh >>> 18) | (el << 14)) ^ ((eh << 23) | (el >>> 9));
				                var sigma1l = ((el >>> 14) | (eh << 18)) ^ ((el >>> 18) | (eh << 14)) ^ ((el << 23) | (eh >>> 9));

				                // t1 = h + sigma1 + ch + K[i] + W[i]
				                var Ki  = K[i];
				                var Kih = Ki.high;
				                var Kil = Ki.low;

				                var t1l = hl + sigma1l;
				                var t1h = hh + sigma1h + ((t1l >>> 0) < (hl >>> 0) ? 1 : 0);
				                var t1l = t1l + chl;
				                var t1h = t1h + chh + ((t1l >>> 0) < (chl >>> 0) ? 1 : 0);
				                var t1l = t1l + Kil;
				                var t1h = t1h + Kih + ((t1l >>> 0) < (Kil >>> 0) ? 1 : 0);
				                var t1l = t1l + Wil;
				                var t1h = t1h + Wih + ((t1l >>> 0) < (Wil >>> 0) ? 1 : 0);

				                // t2 = sigma0 + maj
				                var t2l = sigma0l + majl;
				                var t2h = sigma0h + majh + ((t2l >>> 0) < (sigma0l >>> 0) ? 1 : 0);

				                // Update working variables
				                hh = gh;
				                hl = gl;
				                gh = fh;
				                gl = fl;
				                fh = eh;
				                fl = el;
				                el = (dl + t1l) | 0;
				                eh = (dh + t1h + ((el >>> 0) < (dl >>> 0) ? 1 : 0)) | 0;
				                dh = ch;
				                dl = cl;
				                ch = bh;
				                cl = bl;
				                bh = ah;
				                bl = al;
				                al = (t1l + t2l) | 0;
				                ah = (t1h + t2h + ((al >>> 0) < (t1l >>> 0) ? 1 : 0)) | 0;
				            }

				            // Intermediate hash value
				            H0l = H0.low  = (H0l + al);
				            H0.high = (H0h + ah + ((H0l >>> 0) < (al >>> 0) ? 1 : 0));
				            H1l = H1.low  = (H1l + bl);
				            H1.high = (H1h + bh + ((H1l >>> 0) < (bl >>> 0) ? 1 : 0));
				            H2l = H2.low  = (H2l + cl);
				            H2.high = (H2h + ch + ((H2l >>> 0) < (cl >>> 0) ? 1 : 0));
				            H3l = H3.low  = (H3l + dl);
				            H3.high = (H3h + dh + ((H3l >>> 0) < (dl >>> 0) ? 1 : 0));
				            H4l = H4.low  = (H4l + el);
				            H4.high = (H4h + eh + ((H4l >>> 0) < (el >>> 0) ? 1 : 0));
				            H5l = H5.low  = (H5l + fl);
				            H5.high = (H5h + fh + ((H5l >>> 0) < (fl >>> 0) ? 1 : 0));
				            H6l = H6.low  = (H6l + gl);
				            H6.high = (H6h + gh + ((H6l >>> 0) < (gl >>> 0) ? 1 : 0));
				            H7l = H7.low  = (H7l + hl);
				            H7.high = (H7h + hh + ((H7l >>> 0) < (hl >>> 0) ? 1 : 0));
				        },

				        _doFinalize: function () {
				            // Shortcuts
				            var data = this._data;
				            var dataWords = data.words;

				            var nBitsTotal = this._nDataBytes * 8;
				            var nBitsLeft = data.sigBytes * 8;

				            // Add padding
				            dataWords[nBitsLeft >>> 5] |= 0x80 << (24 - nBitsLeft % 32);
				            dataWords[(((nBitsLeft + 128) >>> 10) << 5) + 30] = Math.floor(nBitsTotal / 0x100000000);
				            dataWords[(((nBitsLeft + 128) >>> 10) << 5) + 31] = nBitsTotal;
				            data.sigBytes = dataWords.length * 4;

				            // Hash final blocks
				            this._process();

				            // Convert hash to 32-bit word array before returning
				            var hash = this._hash.toX32();

				            // Return final computed hash
				            return hash;
				        },

				        clone: function () {
				            var clone = Hasher.clone.call(this);
				            clone._hash = this._hash.clone();

				            return clone;
				        },

				        blockSize: 1024/32
				    });

				    /**
				     * Shortcut function to the hasher's object interface.
				     *
				     * @param {WordArray|string} message The message to hash.
				     *
				     * @return {WordArray} The hash.
				     *
				     * @static
				     *
				     * @example
				     *
				     *     var hash = CryptoJS.SHA512('message');
				     *     var hash = CryptoJS.SHA512(wordArray);
				     */
				    C.SHA512 = Hasher._createHelper(SHA512);

				    /**
				     * Shortcut function to the HMAC's object interface.
				     *
				     * @param {WordArray|string} message The message to hash.
				     * @param {WordArray|string} key The secret key.
				     *
				     * @return {WordArray} The HMAC.
				     *
				     * @static
				     *
				     * @example
				     *
				     *     var hmac = CryptoJS.HmacSHA512(message, key);
				     */
				    C.HmacSHA512 = Hasher._createHmacHelper(SHA512);
				}());


				return CryptoJS.SHA512;

			}));
		} (sha512));
		return sha512.exports;
	}

	var sha384 = {exports: {}};

	var hasRequiredSha384;

	function requireSha384 () {
		if (hasRequiredSha384) return sha384.exports;
		hasRequiredSha384 = 1;
		(function (module, exports) {
	(function (root, factory, undef) {
				{
					// CommonJS
					module.exports = factory(requireCore(), requireX64Core(), requireSha512());
				}
			}(commonjsGlobal, function (CryptoJS) {

				(function () {
				    // Shortcuts
				    var C = CryptoJS;
				    var C_x64 = C.x64;
				    var X64Word = C_x64.Word;
				    var X64WordArray = C_x64.WordArray;
				    var C_algo = C.algo;
				    var SHA512 = C_algo.SHA512;

				    /**
				     * SHA-384 hash algorithm.
				     */
				    var SHA384 = C_algo.SHA384 = SHA512.extend({
				        _doReset: function () {
				            this._hash = new X64WordArray.init([
				                new X64Word.init(0xcbbb9d5d, 0xc1059ed8), new X64Word.init(0x629a292a, 0x367cd507),
				                new X64Word.init(0x9159015a, 0x3070dd17), new X64Word.init(0x152fecd8, 0xf70e5939),
				                new X64Word.init(0x67332667, 0xffc00b31), new X64Word.init(0x8eb44a87, 0x68581511),
				                new X64Word.init(0xdb0c2e0d, 0x64f98fa7), new X64Word.init(0x47b5481d, 0xbefa4fa4)
				            ]);
				        },

				        _doFinalize: function () {
				            var hash = SHA512._doFinalize.call(this);

				            hash.sigBytes -= 16;

				            return hash;
				        }
				    });

				    /**
				     * Shortcut function to the hasher's object interface.
				     *
				     * @param {WordArray|string} message The message to hash.
				     *
				     * @return {WordArray} The hash.
				     *
				     * @static
				     *
				     * @example
				     *
				     *     var hash = CryptoJS.SHA384('message');
				     *     var hash = CryptoJS.SHA384(wordArray);
				     */
				    C.SHA384 = SHA512._createHelper(SHA384);

				    /**
				     * Shortcut function to the HMAC's object interface.
				     *
				     * @param {WordArray|string} message The message to hash.
				     * @param {WordArray|string} key The secret key.
				     *
				     * @return {WordArray} The HMAC.
				     *
				     * @static
				     *
				     * @example
				     *
				     *     var hmac = CryptoJS.HmacSHA384(message, key);
				     */
				    C.HmacSHA384 = SHA512._createHmacHelper(SHA384);
				}());


				return CryptoJS.SHA384;

			}));
		} (sha384));
		return sha384.exports;
	}

	var sha3 = {exports: {}};

	var hasRequiredSha3;

	function requireSha3 () {
		if (hasRequiredSha3) return sha3.exports;
		hasRequiredSha3 = 1;
		(function (module, exports) {
	(function (root, factory, undef) {
				{
					// CommonJS
					module.exports = factory(requireCore(), requireX64Core());
				}
			}(commonjsGlobal, function (CryptoJS) {

				(function (Math) {
				    // Shortcuts
				    var C = CryptoJS;
				    var C_lib = C.lib;
				    var WordArray = C_lib.WordArray;
				    var Hasher = C_lib.Hasher;
				    var C_x64 = C.x64;
				    var X64Word = C_x64.Word;
				    var C_algo = C.algo;

				    // Constants tables
				    var RHO_OFFSETS = [];
				    var PI_INDEXES  = [];
				    var ROUND_CONSTANTS = [];

				    // Compute Constants
				    (function () {
				        // Compute rho offset constants
				        var x = 1, y = 0;
				        for (var t = 0; t < 24; t++) {
				            RHO_OFFSETS[x + 5 * y] = ((t + 1) * (t + 2) / 2) % 64;

				            var newX = y % 5;
				            var newY = (2 * x + 3 * y) % 5;
				            x = newX;
				            y = newY;
				        }

				        // Compute pi index constants
				        for (var x = 0; x < 5; x++) {
				            for (var y = 0; y < 5; y++) {
				                PI_INDEXES[x + 5 * y] = y + ((2 * x + 3 * y) % 5) * 5;
				            }
				        }

				        // Compute round constants
				        var LFSR = 0x01;
				        for (var i = 0; i < 24; i++) {
				            var roundConstantMsw = 0;
				            var roundConstantLsw = 0;

				            for (var j = 0; j < 7; j++) {
				                if (LFSR & 0x01) {
				                    var bitPosition = (1 << j) - 1;
				                    if (bitPosition < 32) {
				                        roundConstantLsw ^= 1 << bitPosition;
				                    } else /* if (bitPosition >= 32) */ {
				                        roundConstantMsw ^= 1 << (bitPosition - 32);
				                    }
				                }

				                // Compute next LFSR
				                if (LFSR & 0x80) {
				                    // Primitive polynomial over GF(2): x^8 + x^6 + x^5 + x^4 + 1
				                    LFSR = (LFSR << 1) ^ 0x71;
				                } else {
				                    LFSR <<= 1;
				                }
				            }

				            ROUND_CONSTANTS[i] = X64Word.create(roundConstantMsw, roundConstantLsw);
				        }
				    }());

				    // Reusable objects for temporary values
				    var T = [];
				    (function () {
				        for (var i = 0; i < 25; i++) {
				            T[i] = X64Word.create();
				        }
				    }());

				    /**
				     * SHA-3 hash algorithm.
				     */
				    var SHA3 = C_algo.SHA3 = Hasher.extend({
				        /**
				         * Configuration options.
				         *
				         * @property {number} outputLength
				         *   The desired number of bits in the output hash.
				         *   Only values permitted are: 224, 256, 384, 512.
				         *   Default: 512
				         */
				        cfg: Hasher.cfg.extend({
				            outputLength: 512
				        }),

				        _doReset: function () {
				            var state = this._state = [];
				            for (var i = 0; i < 25; i++) {
				                state[i] = new X64Word.init();
				            }

				            this.blockSize = (1600 - 2 * this.cfg.outputLength) / 32;
				        },

				        _doProcessBlock: function (M, offset) {
				            // Shortcuts
				            var state = this._state;
				            var nBlockSizeLanes = this.blockSize / 2;

				            // Absorb
				            for (var i = 0; i < nBlockSizeLanes; i++) {
				                // Shortcuts
				                var M2i  = M[offset + 2 * i];
				                var M2i1 = M[offset + 2 * i + 1];

				                // Swap endian
				                M2i = (
				                    (((M2i << 8)  | (M2i >>> 24)) & 0x00ff00ff) |
				                    (((M2i << 24) | (M2i >>> 8))  & 0xff00ff00)
				                );
				                M2i1 = (
				                    (((M2i1 << 8)  | (M2i1 >>> 24)) & 0x00ff00ff) |
				                    (((M2i1 << 24) | (M2i1 >>> 8))  & 0xff00ff00)
				                );

				                // Absorb message into state
				                var lane = state[i];
				                lane.high ^= M2i1;
				                lane.low  ^= M2i;
				            }

				            // Rounds
				            for (var round = 0; round < 24; round++) {
				                // Theta
				                for (var x = 0; x < 5; x++) {
				                    // Mix column lanes
				                    var tMsw = 0, tLsw = 0;
				                    for (var y = 0; y < 5; y++) {
				                        var lane = state[x + 5 * y];
				                        tMsw ^= lane.high;
				                        tLsw ^= lane.low;
				                    }

				                    // Temporary values
				                    var Tx = T[x];
				                    Tx.high = tMsw;
				                    Tx.low  = tLsw;
				                }
				                for (var x = 0; x < 5; x++) {
				                    // Shortcuts
				                    var Tx4 = T[(x + 4) % 5];
				                    var Tx1 = T[(x + 1) % 5];
				                    var Tx1Msw = Tx1.high;
				                    var Tx1Lsw = Tx1.low;

				                    // Mix surrounding columns
				                    var tMsw = Tx4.high ^ ((Tx1Msw << 1) | (Tx1Lsw >>> 31));
				                    var tLsw = Tx4.low  ^ ((Tx1Lsw << 1) | (Tx1Msw >>> 31));
				                    for (var y = 0; y < 5; y++) {
				                        var lane = state[x + 5 * y];
				                        lane.high ^= tMsw;
				                        lane.low  ^= tLsw;
				                    }
				                }

				                // Rho Pi
				                for (var laneIndex = 1; laneIndex < 25; laneIndex++) {
				                    // Shortcuts
				                    var lane = state[laneIndex];
				                    var laneMsw = lane.high;
				                    var laneLsw = lane.low;
				                    var rhoOffset = RHO_OFFSETS[laneIndex];

				                    // Rotate lanes
				                    if (rhoOffset < 32) {
				                        var tMsw = (laneMsw << rhoOffset) | (laneLsw >>> (32 - rhoOffset));
				                        var tLsw = (laneLsw << rhoOffset) | (laneMsw >>> (32 - rhoOffset));
				                    } else /* if (rhoOffset >= 32) */ {
				                        var tMsw = (laneLsw << (rhoOffset - 32)) | (laneMsw >>> (64 - rhoOffset));
				                        var tLsw = (laneMsw << (rhoOffset - 32)) | (laneLsw >>> (64 - rhoOffset));
				                    }

				                    // Transpose lanes
				                    var TPiLane = T[PI_INDEXES[laneIndex]];
				                    TPiLane.high = tMsw;
				                    TPiLane.low  = tLsw;
				                }

				                // Rho pi at x = y = 0
				                var T0 = T[0];
				                var state0 = state[0];
				                T0.high = state0.high;
				                T0.low  = state0.low;

				                // Chi
				                for (var x = 0; x < 5; x++) {
				                    for (var y = 0; y < 5; y++) {
				                        // Shortcuts
				                        var laneIndex = x + 5 * y;
				                        var lane = state[laneIndex];
				                        var TLane = T[laneIndex];
				                        var Tx1Lane = T[((x + 1) % 5) + 5 * y];
				                        var Tx2Lane = T[((x + 2) % 5) + 5 * y];

				                        // Mix rows
				                        lane.high = TLane.high ^ (~Tx1Lane.high & Tx2Lane.high);
				                        lane.low  = TLane.low  ^ (~Tx1Lane.low  & Tx2Lane.low);
				                    }
				                }

				                // Iota
				                var lane = state[0];
				                var roundConstant = ROUND_CONSTANTS[round];
				                lane.high ^= roundConstant.high;
				                lane.low  ^= roundConstant.low;			            }
				        },

				        _doFinalize: function () {
				            // Shortcuts
				            var data = this._data;
				            var dataWords = data.words;
				            this._nDataBytes * 8;
				            var nBitsLeft = data.sigBytes * 8;
				            var blockSizeBits = this.blockSize * 32;

				            // Add padding
				            dataWords[nBitsLeft >>> 5] |= 0x1 << (24 - nBitsLeft % 32);
				            dataWords[((Math.ceil((nBitsLeft + 1) / blockSizeBits) * blockSizeBits) >>> 5) - 1] |= 0x80;
				            data.sigBytes = dataWords.length * 4;

				            // Hash final blocks
				            this._process();

				            // Shortcuts
				            var state = this._state;
				            var outputLengthBytes = this.cfg.outputLength / 8;
				            var outputLengthLanes = outputLengthBytes / 8;

				            // Squeeze
				            var hashWords = [];
				            for (var i = 0; i < outputLengthLanes; i++) {
				                // Shortcuts
				                var lane = state[i];
				                var laneMsw = lane.high;
				                var laneLsw = lane.low;

				                // Swap endian
				                laneMsw = (
				                    (((laneMsw << 8)  | (laneMsw >>> 24)) & 0x00ff00ff) |
				                    (((laneMsw << 24) | (laneMsw >>> 8))  & 0xff00ff00)
				                );
				                laneLsw = (
				                    (((laneLsw << 8)  | (laneLsw >>> 24)) & 0x00ff00ff) |
				                    (((laneLsw << 24) | (laneLsw >>> 8))  & 0xff00ff00)
				                );

				                // Squeeze state to retrieve hash
				                hashWords.push(laneLsw);
				                hashWords.push(laneMsw);
				            }

				            // Return final computed hash
				            return new WordArray.init(hashWords, outputLengthBytes);
				        },

				        clone: function () {
				            var clone = Hasher.clone.call(this);

				            var state = clone._state = this._state.slice(0);
				            for (var i = 0; i < 25; i++) {
				                state[i] = state[i].clone();
				            }

				            return clone;
				        }
				    });

				    /**
				     * Shortcut function to the hasher's object interface.
				     *
				     * @param {WordArray|string} message The message to hash.
				     *
				     * @return {WordArray} The hash.
				     *
				     * @static
				     *
				     * @example
				     *
				     *     var hash = CryptoJS.SHA3('message');
				     *     var hash = CryptoJS.SHA3(wordArray);
				     */
				    C.SHA3 = Hasher._createHelper(SHA3);

				    /**
				     * Shortcut function to the HMAC's object interface.
				     *
				     * @param {WordArray|string} message The message to hash.
				     * @param {WordArray|string} key The secret key.
				     *
				     * @return {WordArray} The HMAC.
				     *
				     * @static
				     *
				     * @example
				     *
				     *     var hmac = CryptoJS.HmacSHA3(message, key);
				     */
				    C.HmacSHA3 = Hasher._createHmacHelper(SHA3);
				}(Math));


				return CryptoJS.SHA3;

			}));
		} (sha3));
		return sha3.exports;
	}

	var ripemd160 = {exports: {}};

	var hasRequiredRipemd160;

	function requireRipemd160 () {
		if (hasRequiredRipemd160) return ripemd160.exports;
		hasRequiredRipemd160 = 1;
		(function (module, exports) {
	(function (root, factory) {
				{
					// CommonJS
					module.exports = factory(requireCore());
				}
			}(commonjsGlobal, function (CryptoJS) {

				/** @preserve
				(c) 2012 by Cédric Mesnil. All rights reserved.

				Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

				    - Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
				    - Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

				THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
				*/

				(function (Math) {
				    // Shortcuts
				    var C = CryptoJS;
				    var C_lib = C.lib;
				    var WordArray = C_lib.WordArray;
				    var Hasher = C_lib.Hasher;
				    var C_algo = C.algo;

				    // Constants table
				    var _zl = WordArray.create([
				        0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15,
				        7,  4, 13,  1, 10,  6, 15,  3, 12,  0,  9,  5,  2, 14, 11,  8,
				        3, 10, 14,  4,  9, 15,  8,  1,  2,  7,  0,  6, 13, 11,  5, 12,
				        1,  9, 11, 10,  0,  8, 12,  4, 13,  3,  7, 15, 14,  5,  6,  2,
				        4,  0,  5,  9,  7, 12,  2, 10, 14,  1,  3,  8, 11,  6, 15, 13]);
				    var _zr = WordArray.create([
				        5, 14,  7,  0,  9,  2, 11,  4, 13,  6, 15,  8,  1, 10,  3, 12,
				        6, 11,  3,  7,  0, 13,  5, 10, 14, 15,  8, 12,  4,  9,  1,  2,
				        15,  5,  1,  3,  7, 14,  6,  9, 11,  8, 12,  2, 10,  0,  4, 13,
				        8,  6,  4,  1,  3, 11, 15,  0,  5, 12,  2, 13,  9,  7, 10, 14,
				        12, 15, 10,  4,  1,  5,  8,  7,  6,  2, 13, 14,  0,  3,  9, 11]);
				    var _sl = WordArray.create([
				         11, 14, 15, 12,  5,  8,  7,  9, 11, 13, 14, 15,  6,  7,  9,  8,
				        7, 6,   8, 13, 11,  9,  7, 15,  7, 12, 15,  9, 11,  7, 13, 12,
				        11, 13,  6,  7, 14,  9, 13, 15, 14,  8, 13,  6,  5, 12,  7,  5,
				          11, 12, 14, 15, 14, 15,  9,  8,  9, 14,  5,  6,  8,  6,  5, 12,
				        9, 15,  5, 11,  6,  8, 13, 12,  5, 12, 13, 14, 11,  8,  5,  6 ]);
				    var _sr = WordArray.create([
				        8,  9,  9, 11, 13, 15, 15,  5,  7,  7,  8, 11, 14, 14, 12,  6,
				        9, 13, 15,  7, 12,  8,  9, 11,  7,  7, 12,  7,  6, 15, 13, 11,
				        9,  7, 15, 11,  8,  6,  6, 14, 12, 13,  5, 14, 13, 13,  7,  5,
				        15,  5,  8, 11, 14, 14,  6, 14,  6,  9, 12,  9, 12,  5, 15,  8,
				        8,  5, 12,  9, 12,  5, 14,  6,  8, 13,  6,  5, 15, 13, 11, 11 ]);

				    var _hl =  WordArray.create([ 0x00000000, 0x5A827999, 0x6ED9EBA1, 0x8F1BBCDC, 0xA953FD4E]);
				    var _hr =  WordArray.create([ 0x50A28BE6, 0x5C4DD124, 0x6D703EF3, 0x7A6D76E9, 0x00000000]);

				    /**
				     * RIPEMD160 hash algorithm.
				     */
				    var RIPEMD160 = C_algo.RIPEMD160 = Hasher.extend({
				        _doReset: function () {
				            this._hash  = WordArray.create([0x67452301, 0xEFCDAB89, 0x98BADCFE, 0x10325476, 0xC3D2E1F0]);
				        },

				        _doProcessBlock: function (M, offset) {

				            // Swap endian
				            for (var i = 0; i < 16; i++) {
				                // Shortcuts
				                var offset_i = offset + i;
				                var M_offset_i = M[offset_i];

				                // Swap
				                M[offset_i] = (
				                    (((M_offset_i << 8)  | (M_offset_i >>> 24)) & 0x00ff00ff) |
				                    (((M_offset_i << 24) | (M_offset_i >>> 8))  & 0xff00ff00)
				                );
				            }
				            // Shortcut
				            var H  = this._hash.words;
				            var hl = _hl.words;
				            var hr = _hr.words;
				            var zl = _zl.words;
				            var zr = _zr.words;
				            var sl = _sl.words;
				            var sr = _sr.words;

				            // Working variables
				            var al, bl, cl, dl, el;
				            var ar, br, cr, dr, er;

				            ar = al = H[0];
				            br = bl = H[1];
				            cr = cl = H[2];
				            dr = dl = H[3];
				            er = el = H[4];
				            // Computation
				            var t;
				            for (var i = 0; i < 80; i += 1) {
				                t = (al +  M[offset+zl[i]])|0;
				                if (i<16){
					            t +=  f1(bl,cl,dl) + hl[0];
				                } else if (i<32) {
					            t +=  f2(bl,cl,dl) + hl[1];
				                } else if (i<48) {
					            t +=  f3(bl,cl,dl) + hl[2];
				                } else if (i<64) {
					            t +=  f4(bl,cl,dl) + hl[3];
				                } else {// if (i<80) {
					            t +=  f5(bl,cl,dl) + hl[4];
				                }
				                t = t|0;
				                t =  rotl(t,sl[i]);
				                t = (t+el)|0;
				                al = el;
				                el = dl;
				                dl = rotl(cl, 10);
				                cl = bl;
				                bl = t;

				                t = (ar + M[offset+zr[i]])|0;
				                if (i<16){
					            t +=  f5(br,cr,dr) + hr[0];
				                } else if (i<32) {
					            t +=  f4(br,cr,dr) + hr[1];
				                } else if (i<48) {
					            t +=  f3(br,cr,dr) + hr[2];
				                } else if (i<64) {
					            t +=  f2(br,cr,dr) + hr[3];
				                } else {// if (i<80) {
					            t +=  f1(br,cr,dr) + hr[4];
				                }
				                t = t|0;
				                t =  rotl(t,sr[i]) ;
				                t = (t+er)|0;
				                ar = er;
				                er = dr;
				                dr = rotl(cr, 10);
				                cr = br;
				                br = t;
				            }
				            // Intermediate hash value
				            t    = (H[1] + cl + dr)|0;
				            H[1] = (H[2] + dl + er)|0;
				            H[2] = (H[3] + el + ar)|0;
				            H[3] = (H[4] + al + br)|0;
				            H[4] = (H[0] + bl + cr)|0;
				            H[0] =  t;
				        },

				        _doFinalize: function () {
				            // Shortcuts
				            var data = this._data;
				            var dataWords = data.words;

				            var nBitsTotal = this._nDataBytes * 8;
				            var nBitsLeft = data.sigBytes * 8;

				            // Add padding
				            dataWords[nBitsLeft >>> 5] |= 0x80 << (24 - nBitsLeft % 32);
				            dataWords[(((nBitsLeft + 64) >>> 9) << 4) + 14] = (
				                (((nBitsTotal << 8)  | (nBitsTotal >>> 24)) & 0x00ff00ff) |
				                (((nBitsTotal << 24) | (nBitsTotal >>> 8))  & 0xff00ff00)
				            );
				            data.sigBytes = (dataWords.length + 1) * 4;

				            // Hash final blocks
				            this._process();

				            // Shortcuts
				            var hash = this._hash;
				            var H = hash.words;

				            // Swap endian
				            for (var i = 0; i < 5; i++) {
				                // Shortcut
				                var H_i = H[i];

				                // Swap
				                H[i] = (((H_i << 8)  | (H_i >>> 24)) & 0x00ff00ff) |
				                       (((H_i << 24) | (H_i >>> 8))  & 0xff00ff00);
				            }

				            // Return final computed hash
				            return hash;
				        },

				        clone: function () {
				            var clone = Hasher.clone.call(this);
				            clone._hash = this._hash.clone();

				            return clone;
				        }
				    });


				    function f1(x, y, z) {
				        return ((x) ^ (y) ^ (z));

				    }

				    function f2(x, y, z) {
				        return (((x)&(y)) | ((~x)&(z)));
				    }

				    function f3(x, y, z) {
				        return (((x) | (~(y))) ^ (z));
				    }

				    function f4(x, y, z) {
				        return (((x) & (z)) | ((y)&(~(z))));
				    }

				    function f5(x, y, z) {
				        return ((x) ^ ((y) |(~(z))));

				    }

				    function rotl(x,n) {
				        return (x<<n) | (x>>>(32-n));
				    }


				    /**
				     * Shortcut function to the hasher's object interface.
				     *
				     * @param {WordArray|string} message The message to hash.
				     *
				     * @return {WordArray} The hash.
				     *
				     * @static
				     *
				     * @example
				     *
				     *     var hash = CryptoJS.RIPEMD160('message');
				     *     var hash = CryptoJS.RIPEMD160(wordArray);
				     */
				    C.RIPEMD160 = Hasher._createHelper(RIPEMD160);

				    /**
				     * Shortcut function to the HMAC's object interface.
				     *
				     * @param {WordArray|string} message The message to hash.
				     * @param {WordArray|string} key The secret key.
				     *
				     * @return {WordArray} The HMAC.
				     *
				     * @static
				     *
				     * @example
				     *
				     *     var hmac = CryptoJS.HmacRIPEMD160(message, key);
				     */
				    C.HmacRIPEMD160 = Hasher._createHmacHelper(RIPEMD160);
				}());


				return CryptoJS.RIPEMD160;

			}));
		} (ripemd160));
		return ripemd160.exports;
	}

	var hmac = {exports: {}};

	var hasRequiredHmac;

	function requireHmac () {
		if (hasRequiredHmac) return hmac.exports;
		hasRequiredHmac = 1;
		(function (module, exports) {
	(function (root, factory) {
				{
					// CommonJS
					module.exports = factory(requireCore());
				}
			}(commonjsGlobal, function (CryptoJS) {

				(function () {
				    // Shortcuts
				    var C = CryptoJS;
				    var C_lib = C.lib;
				    var Base = C_lib.Base;
				    var C_enc = C.enc;
				    var Utf8 = C_enc.Utf8;
				    var C_algo = C.algo;

				    /**
				     * HMAC algorithm.
				     */
				    C_algo.HMAC = Base.extend({
				        /**
				         * Initializes a newly created HMAC.
				         *
				         * @param {Hasher} hasher The hash algorithm to use.
				         * @param {WordArray|string} key The secret key.
				         *
				         * @example
				         *
				         *     var hmacHasher = CryptoJS.algo.HMAC.create(CryptoJS.algo.SHA256, key);
				         */
				        init: function (hasher, key) {
				            // Init hasher
				            hasher = this._hasher = new hasher.init();

				            // Convert string to WordArray, else assume WordArray already
				            if (typeof key == 'string') {
				                key = Utf8.parse(key);
				            }

				            // Shortcuts
				            var hasherBlockSize = hasher.blockSize;
				            var hasherBlockSizeBytes = hasherBlockSize * 4;

				            // Allow arbitrary length keys
				            if (key.sigBytes > hasherBlockSizeBytes) {
				                key = hasher.finalize(key);
				            }

				            // Clamp excess bits
				            key.clamp();

				            // Clone key for inner and outer pads
				            var oKey = this._oKey = key.clone();
				            var iKey = this._iKey = key.clone();

				            // Shortcuts
				            var oKeyWords = oKey.words;
				            var iKeyWords = iKey.words;

				            // XOR keys with pad constants
				            for (var i = 0; i < hasherBlockSize; i++) {
				                oKeyWords[i] ^= 0x5c5c5c5c;
				                iKeyWords[i] ^= 0x36363636;
				            }
				            oKey.sigBytes = iKey.sigBytes = hasherBlockSizeBytes;

				            // Set initial values
				            this.reset();
				        },

				        /**
				         * Resets this HMAC to its initial state.
				         *
				         * @example
				         *
				         *     hmacHasher.reset();
				         */
				        reset: function () {
				            // Shortcut
				            var hasher = this._hasher;

				            // Reset
				            hasher.reset();
				            hasher.update(this._iKey);
				        },

				        /**
				         * Updates this HMAC with a message.
				         *
				         * @param {WordArray|string} messageUpdate The message to append.
				         *
				         * @return {HMAC} This HMAC instance.
				         *
				         * @example
				         *
				         *     hmacHasher.update('message');
				         *     hmacHasher.update(wordArray);
				         */
				        update: function (messageUpdate) {
				            this._hasher.update(messageUpdate);

				            // Chainable
				            return this;
				        },

				        /**
				         * Finalizes the HMAC computation.
				         * Note that the finalize operation is effectively a destructive, read-once operation.
				         *
				         * @param {WordArray|string} messageUpdate (Optional) A final message update.
				         *
				         * @return {WordArray} The HMAC.
				         *
				         * @example
				         *
				         *     var hmac = hmacHasher.finalize();
				         *     var hmac = hmacHasher.finalize('message');
				         *     var hmac = hmacHasher.finalize(wordArray);
				         */
				        finalize: function (messageUpdate) {
				            // Shortcut
				            var hasher = this._hasher;

				            // Compute HMAC
				            var innerHash = hasher.finalize(messageUpdate);
				            hasher.reset();
				            var hmac = hasher.finalize(this._oKey.clone().concat(innerHash));

				            return hmac;
				        }
				    });
				}());


			}));
		} (hmac));
		return hmac.exports;
	}

	var pbkdf2 = {exports: {}};

	var hasRequiredPbkdf2;

	function requirePbkdf2 () {
		if (hasRequiredPbkdf2) return pbkdf2.exports;
		hasRequiredPbkdf2 = 1;
		(function (module, exports) {
	(function (root, factory, undef) {
				{
					// CommonJS
					module.exports = factory(requireCore(), requireSha1(), requireHmac());
				}
			}(commonjsGlobal, function (CryptoJS) {

				(function () {
				    // Shortcuts
				    var C = CryptoJS;
				    var C_lib = C.lib;
				    var Base = C_lib.Base;
				    var WordArray = C_lib.WordArray;
				    var C_algo = C.algo;
				    var SHA1 = C_algo.SHA1;
				    var HMAC = C_algo.HMAC;

				    /**
				     * Password-Based Key Derivation Function 2 algorithm.
				     */
				    var PBKDF2 = C_algo.PBKDF2 = Base.extend({
				        /**
				         * Configuration options.
				         *
				         * @property {number} keySize The key size in words to generate. Default: 4 (128 bits)
				         * @property {Hasher} hasher The hasher to use. Default: SHA1
				         * @property {number} iterations The number of iterations to perform. Default: 1
				         */
				        cfg: Base.extend({
				            keySize: 128/32,
				            hasher: SHA1,
				            iterations: 1
				        }),

				        /**
				         * Initializes a newly created key derivation function.
				         *
				         * @param {Object} cfg (Optional) The configuration options to use for the derivation.
				         *
				         * @example
				         *
				         *     var kdf = CryptoJS.algo.PBKDF2.create();
				         *     var kdf = CryptoJS.algo.PBKDF2.create({ keySize: 8 });
				         *     var kdf = CryptoJS.algo.PBKDF2.create({ keySize: 8, iterations: 1000 });
				         */
				        init: function (cfg) {
				            this.cfg = this.cfg.extend(cfg);
				        },

				        /**
				         * Computes the Password-Based Key Derivation Function 2.
				         *
				         * @param {WordArray|string} password The password.
				         * @param {WordArray|string} salt A salt.
				         *
				         * @return {WordArray} The derived key.
				         *
				         * @example
				         *
				         *     var key = kdf.compute(password, salt);
				         */
				        compute: function (password, salt) {
				            // Shortcut
				            var cfg = this.cfg;

				            // Init HMAC
				            var hmac = HMAC.create(cfg.hasher, password);

				            // Initial values
				            var derivedKey = WordArray.create();
				            var blockIndex = WordArray.create([0x00000001]);

				            // Shortcuts
				            var derivedKeyWords = derivedKey.words;
				            var blockIndexWords = blockIndex.words;
				            var keySize = cfg.keySize;
				            var iterations = cfg.iterations;

				            // Generate key
				            while (derivedKeyWords.length < keySize) {
				                var block = hmac.update(salt).finalize(blockIndex);
				                hmac.reset();

				                // Shortcuts
				                var blockWords = block.words;
				                var blockWordsLength = blockWords.length;

				                // Iterations
				                var intermediate = block;
				                for (var i = 1; i < iterations; i++) {
				                    intermediate = hmac.finalize(intermediate);
				                    hmac.reset();

				                    // Shortcut
				                    var intermediateWords = intermediate.words;

				                    // XOR intermediate with block
				                    for (var j = 0; j < blockWordsLength; j++) {
				                        blockWords[j] ^= intermediateWords[j];
				                    }
				                }

				                derivedKey.concat(block);
				                blockIndexWords[0]++;
				            }
				            derivedKey.sigBytes = keySize * 4;

				            return derivedKey;
				        }
				    });

				    /**
				     * Computes the Password-Based Key Derivation Function 2.
				     *
				     * @param {WordArray|string} password The password.
				     * @param {WordArray|string} salt A salt.
				     * @param {Object} cfg (Optional) The configuration options to use for this computation.
				     *
				     * @return {WordArray} The derived key.
				     *
				     * @static
				     *
				     * @example
				     *
				     *     var key = CryptoJS.PBKDF2(password, salt);
				     *     var key = CryptoJS.PBKDF2(password, salt, { keySize: 8 });
				     *     var key = CryptoJS.PBKDF2(password, salt, { keySize: 8, iterations: 1000 });
				     */
				    C.PBKDF2 = function (password, salt, cfg) {
				        return PBKDF2.create(cfg).compute(password, salt);
				    };
				}());


				return CryptoJS.PBKDF2;

			}));
		} (pbkdf2));
		return pbkdf2.exports;
	}

	var evpkdf = {exports: {}};

	var hasRequiredEvpkdf;

	function requireEvpkdf () {
		if (hasRequiredEvpkdf) return evpkdf.exports;
		hasRequiredEvpkdf = 1;
		(function (module, exports) {
	(function (root, factory, undef) {
				{
					// CommonJS
					module.exports = factory(requireCore(), requireSha1(), requireHmac());
				}
			}(commonjsGlobal, function (CryptoJS) {

				(function () {
				    // Shortcuts
				    var C = CryptoJS;
				    var C_lib = C.lib;
				    var Base = C_lib.Base;
				    var WordArray = C_lib.WordArray;
				    var C_algo = C.algo;
				    var MD5 = C_algo.MD5;

				    /**
				     * This key derivation function is meant to conform with EVP_BytesToKey.
				     * www.openssl.org/docs/crypto/EVP_BytesToKey.html
				     */
				    var EvpKDF = C_algo.EvpKDF = Base.extend({
				        /**
				         * Configuration options.
				         *
				         * @property {number} keySize The key size in words to generate. Default: 4 (128 bits)
				         * @property {Hasher} hasher The hash algorithm to use. Default: MD5
				         * @property {number} iterations The number of iterations to perform. Default: 1
				         */
				        cfg: Base.extend({
				            keySize: 128/32,
				            hasher: MD5,
				            iterations: 1
				        }),

				        /**
				         * Initializes a newly created key derivation function.
				         *
				         * @param {Object} cfg (Optional) The configuration options to use for the derivation.
				         *
				         * @example
				         *
				         *     var kdf = CryptoJS.algo.EvpKDF.create();
				         *     var kdf = CryptoJS.algo.EvpKDF.create({ keySize: 8 });
				         *     var kdf = CryptoJS.algo.EvpKDF.create({ keySize: 8, iterations: 1000 });
				         */
				        init: function (cfg) {
				            this.cfg = this.cfg.extend(cfg);
				        },

				        /**
				         * Derives a key from a password.
				         *
				         * @param {WordArray|string} password The password.
				         * @param {WordArray|string} salt A salt.
				         *
				         * @return {WordArray} The derived key.
				         *
				         * @example
				         *
				         *     var key = kdf.compute(password, salt);
				         */
				        compute: function (password, salt) {
				            // Shortcut
				            var cfg = this.cfg;

				            // Init hasher
				            var hasher = cfg.hasher.create();

				            // Initial values
				            var derivedKey = WordArray.create();

				            // Shortcuts
				            var derivedKeyWords = derivedKey.words;
				            var keySize = cfg.keySize;
				            var iterations = cfg.iterations;

				            // Generate key
				            while (derivedKeyWords.length < keySize) {
				                if (block) {
				                    hasher.update(block);
				                }
				                var block = hasher.update(password).finalize(salt);
				                hasher.reset();

				                // Iterations
				                for (var i = 1; i < iterations; i++) {
				                    block = hasher.finalize(block);
				                    hasher.reset();
				                }

				                derivedKey.concat(block);
				            }
				            derivedKey.sigBytes = keySize * 4;

				            return derivedKey;
				        }
				    });

				    /**
				     * Derives a key from a password.
				     *
				     * @param {WordArray|string} password The password.
				     * @param {WordArray|string} salt A salt.
				     * @param {Object} cfg (Optional) The configuration options to use for this computation.
				     *
				     * @return {WordArray} The derived key.
				     *
				     * @static
				     *
				     * @example
				     *
				     *     var key = CryptoJS.EvpKDF(password, salt);
				     *     var key = CryptoJS.EvpKDF(password, salt, { keySize: 8 });
				     *     var key = CryptoJS.EvpKDF(password, salt, { keySize: 8, iterations: 1000 });
				     */
				    C.EvpKDF = function (password, salt, cfg) {
				        return EvpKDF.create(cfg).compute(password, salt);
				    };
				}());


				return CryptoJS.EvpKDF;

			}));
		} (evpkdf));
		return evpkdf.exports;
	}

	var cipherCore = {exports: {}};

	var hasRequiredCipherCore;

	function requireCipherCore () {
		if (hasRequiredCipherCore) return cipherCore.exports;
		hasRequiredCipherCore = 1;
		(function (module, exports) {
	(function (root, factory, undef) {
				{
					// CommonJS
					module.exports = factory(requireCore(), requireEvpkdf());
				}
			}(commonjsGlobal, function (CryptoJS) {

				/**
				 * Cipher core components.
				 */
				CryptoJS.lib.Cipher || (function (undefined$1) {
				    // Shortcuts
				    var C = CryptoJS;
				    var C_lib = C.lib;
				    var Base = C_lib.Base;
				    var WordArray = C_lib.WordArray;
				    var BufferedBlockAlgorithm = C_lib.BufferedBlockAlgorithm;
				    var C_enc = C.enc;
				    C_enc.Utf8;
				    var Base64 = C_enc.Base64;
				    var C_algo = C.algo;
				    var EvpKDF = C_algo.EvpKDF;

				    /**
				     * Abstract base cipher template.
				     *
				     * @property {number} keySize This cipher's key size. Default: 4 (128 bits)
				     * @property {number} ivSize This cipher's IV size. Default: 4 (128 bits)
				     * @property {number} _ENC_XFORM_MODE A constant representing encryption mode.
				     * @property {number} _DEC_XFORM_MODE A constant representing decryption mode.
				     */
				    var Cipher = C_lib.Cipher = BufferedBlockAlgorithm.extend({
				        /**
				         * Configuration options.
				         *
				         * @property {WordArray} iv The IV to use for this operation.
				         */
				        cfg: Base.extend(),

				        /**
				         * Creates this cipher in encryption mode.
				         *
				         * @param {WordArray} key The key.
				         * @param {Object} cfg (Optional) The configuration options to use for this operation.
				         *
				         * @return {Cipher} A cipher instance.
				         *
				         * @static
				         *
				         * @example
				         *
				         *     var cipher = CryptoJS.algo.AES.createEncryptor(keyWordArray, { iv: ivWordArray });
				         */
				        createEncryptor: function (key, cfg) {
				            return this.create(this._ENC_XFORM_MODE, key, cfg);
				        },

				        /**
				         * Creates this cipher in decryption mode.
				         *
				         * @param {WordArray} key The key.
				         * @param {Object} cfg (Optional) The configuration options to use for this operation.
				         *
				         * @return {Cipher} A cipher instance.
				         *
				         * @static
				         *
				         * @example
				         *
				         *     var cipher = CryptoJS.algo.AES.createDecryptor(keyWordArray, { iv: ivWordArray });
				         */
				        createDecryptor: function (key, cfg) {
				            return this.create(this._DEC_XFORM_MODE, key, cfg);
				        },

				        /**
				         * Initializes a newly created cipher.
				         *
				         * @param {number} xformMode Either the encryption or decryption transormation mode constant.
				         * @param {WordArray} key The key.
				         * @param {Object} cfg (Optional) The configuration options to use for this operation.
				         *
				         * @example
				         *
				         *     var cipher = CryptoJS.algo.AES.create(CryptoJS.algo.AES._ENC_XFORM_MODE, keyWordArray, { iv: ivWordArray });
				         */
				        init: function (xformMode, key, cfg) {
				            // Apply config defaults
				            this.cfg = this.cfg.extend(cfg);

				            // Store transform mode and key
				            this._xformMode = xformMode;
				            this._key = key;

				            // Set initial values
				            this.reset();
				        },

				        /**
				         * Resets this cipher to its initial state.
				         *
				         * @example
				         *
				         *     cipher.reset();
				         */
				        reset: function () {
				            // Reset data buffer
				            BufferedBlockAlgorithm.reset.call(this);

				            // Perform concrete-cipher logic
				            this._doReset();
				        },

				        /**
				         * Adds data to be encrypted or decrypted.
				         *
				         * @param {WordArray|string} dataUpdate The data to encrypt or decrypt.
				         *
				         * @return {WordArray} The data after processing.
				         *
				         * @example
				         *
				         *     var encrypted = cipher.process('data');
				         *     var encrypted = cipher.process(wordArray);
				         */
				        process: function (dataUpdate) {
				            // Append
				            this._append(dataUpdate);

				            // Process available blocks
				            return this._process();
				        },

				        /**
				         * Finalizes the encryption or decryption process.
				         * Note that the finalize operation is effectively a destructive, read-once operation.
				         *
				         * @param {WordArray|string} dataUpdate The final data to encrypt or decrypt.
				         *
				         * @return {WordArray} The data after final processing.
				         *
				         * @example
				         *
				         *     var encrypted = cipher.finalize();
				         *     var encrypted = cipher.finalize('data');
				         *     var encrypted = cipher.finalize(wordArray);
				         */
				        finalize: function (dataUpdate) {
				            // Final data update
				            if (dataUpdate) {
				                this._append(dataUpdate);
				            }

				            // Perform concrete-cipher logic
				            var finalProcessedData = this._doFinalize();

				            return finalProcessedData;
				        },

				        keySize: 128/32,

				        ivSize: 128/32,

				        _ENC_XFORM_MODE: 1,

				        _DEC_XFORM_MODE: 2,

				        /**
				         * Creates shortcut functions to a cipher's object interface.
				         *
				         * @param {Cipher} cipher The cipher to create a helper for.
				         *
				         * @return {Object} An object with encrypt and decrypt shortcut functions.
				         *
				         * @static
				         *
				         * @example
				         *
				         *     var AES = CryptoJS.lib.Cipher._createHelper(CryptoJS.algo.AES);
				         */
				        _createHelper: (function () {
				            function selectCipherStrategy(key) {
				                if (typeof key == 'string') {
				                    return PasswordBasedCipher;
				                } else {
				                    return SerializableCipher;
				                }
				            }

				            return function (cipher) {
				                return {
				                    encrypt: function (message, key, cfg) {
				                        return selectCipherStrategy(key).encrypt(cipher, message, key, cfg);
				                    },

				                    decrypt: function (ciphertext, key, cfg) {
				                        return selectCipherStrategy(key).decrypt(cipher, ciphertext, key, cfg);
				                    }
				                };
				            };
				        }())
				    });

				    /**
				     * Abstract base stream cipher template.
				     *
				     * @property {number} blockSize The number of 32-bit words this cipher operates on. Default: 1 (32 bits)
				     */
				    C_lib.StreamCipher = Cipher.extend({
				        _doFinalize: function () {
				            // Process partial blocks
				            var finalProcessedBlocks = this._process(!!'flush');

				            return finalProcessedBlocks;
				        },

				        blockSize: 1
				    });

				    /**
				     * Mode namespace.
				     */
				    var C_mode = C.mode = {};

				    /**
				     * Abstract base block cipher mode template.
				     */
				    var BlockCipherMode = C_lib.BlockCipherMode = Base.extend({
				        /**
				         * Creates this mode for encryption.
				         *
				         * @param {Cipher} cipher A block cipher instance.
				         * @param {Array} iv The IV words.
				         *
				         * @static
				         *
				         * @example
				         *
				         *     var mode = CryptoJS.mode.CBC.createEncryptor(cipher, iv.words);
				         */
				        createEncryptor: function (cipher, iv) {
				            return this.Encryptor.create(cipher, iv);
				        },

				        /**
				         * Creates this mode for decryption.
				         *
				         * @param {Cipher} cipher A block cipher instance.
				         * @param {Array} iv The IV words.
				         *
				         * @static
				         *
				         * @example
				         *
				         *     var mode = CryptoJS.mode.CBC.createDecryptor(cipher, iv.words);
				         */
				        createDecryptor: function (cipher, iv) {
				            return this.Decryptor.create(cipher, iv);
				        },

				        /**
				         * Initializes a newly created mode.
				         *
				         * @param {Cipher} cipher A block cipher instance.
				         * @param {Array} iv The IV words.
				         *
				         * @example
				         *
				         *     var mode = CryptoJS.mode.CBC.Encryptor.create(cipher, iv.words);
				         */
				        init: function (cipher, iv) {
				            this._cipher = cipher;
				            this._iv = iv;
				        }
				    });

				    /**
				     * Cipher Block Chaining mode.
				     */
				    var CBC = C_mode.CBC = (function () {
				        /**
				         * Abstract base CBC mode.
				         */
				        var CBC = BlockCipherMode.extend();

				        /**
				         * CBC encryptor.
				         */
				        CBC.Encryptor = CBC.extend({
				            /**
				             * Processes the data block at offset.
				             *
				             * @param {Array} words The data words to operate on.
				             * @param {number} offset The offset where the block starts.
				             *
				             * @example
				             *
				             *     mode.processBlock(data.words, offset);
				             */
				            processBlock: function (words, offset) {
				                // Shortcuts
				                var cipher = this._cipher;
				                var blockSize = cipher.blockSize;

				                // XOR and encrypt
				                xorBlock.call(this, words, offset, blockSize);
				                cipher.encryptBlock(words, offset);

				                // Remember this block to use with next block
				                this._prevBlock = words.slice(offset, offset + blockSize);
				            }
				        });

				        /**
				         * CBC decryptor.
				         */
				        CBC.Decryptor = CBC.extend({
				            /**
				             * Processes the data block at offset.
				             *
				             * @param {Array} words The data words to operate on.
				             * @param {number} offset The offset where the block starts.
				             *
				             * @example
				             *
				             *     mode.processBlock(data.words, offset);
				             */
				            processBlock: function (words, offset) {
				                // Shortcuts
				                var cipher = this._cipher;
				                var blockSize = cipher.blockSize;

				                // Remember this block to use with next block
				                var thisBlock = words.slice(offset, offset + blockSize);

				                // Decrypt and XOR
				                cipher.decryptBlock(words, offset);
				                xorBlock.call(this, words, offset, blockSize);

				                // This block becomes the previous block
				                this._prevBlock = thisBlock;
				            }
				        });

				        function xorBlock(words, offset, blockSize) {
				            // Shortcut
				            var iv = this._iv;

				            // Choose mixing block
				            if (iv) {
				                var block = iv;

				                // Remove IV for subsequent blocks
				                this._iv = undefined$1;
				            } else {
				                var block = this._prevBlock;
				            }

				            // XOR blocks
				            for (var i = 0; i < blockSize; i++) {
				                words[offset + i] ^= block[i];
				            }
				        }

				        return CBC;
				    }());

				    /**
				     * Padding namespace.
				     */
				    var C_pad = C.pad = {};

				    /**
				     * PKCS #5/7 padding strategy.
				     */
				    var Pkcs7 = C_pad.Pkcs7 = {
				        /**
				         * Pads data using the algorithm defined in PKCS #5/7.
				         *
				         * @param {WordArray} data The data to pad.
				         * @param {number} blockSize The multiple that the data should be padded to.
				         *
				         * @static
				         *
				         * @example
				         *
				         *     CryptoJS.pad.Pkcs7.pad(wordArray, 4);
				         */
				        pad: function (data, blockSize) {
				            // Shortcut
				            var blockSizeBytes = blockSize * 4;

				            // Count padding bytes
				            var nPaddingBytes = blockSizeBytes - data.sigBytes % blockSizeBytes;

				            // Create padding word
				            var paddingWord = (nPaddingBytes << 24) | (nPaddingBytes << 16) | (nPaddingBytes << 8) | nPaddingBytes;

				            // Create padding
				            var paddingWords = [];
				            for (var i = 0; i < nPaddingBytes; i += 4) {
				                paddingWords.push(paddingWord);
				            }
				            var padding = WordArray.create(paddingWords, nPaddingBytes);

				            // Add padding
				            data.concat(padding);
				        },

				        /**
				         * Unpads data that had been padded using the algorithm defined in PKCS #5/7.
				         *
				         * @param {WordArray} data The data to unpad.
				         *
				         * @static
				         *
				         * @example
				         *
				         *     CryptoJS.pad.Pkcs7.unpad(wordArray);
				         */
				        unpad: function (data) {
				            // Get number of padding bytes from last byte
				            var nPaddingBytes = data.words[(data.sigBytes - 1) >>> 2] & 0xff;

				            // Remove padding
				            data.sigBytes -= nPaddingBytes;
				        }
				    };

				    /**
				     * Abstract base block cipher template.
				     *
				     * @property {number} blockSize The number of 32-bit words this cipher operates on. Default: 4 (128 bits)
				     */
				    C_lib.BlockCipher = Cipher.extend({
				        /**
				         * Configuration options.
				         *
				         * @property {Mode} mode The block mode to use. Default: CBC
				         * @property {Padding} padding The padding strategy to use. Default: Pkcs7
				         */
				        cfg: Cipher.cfg.extend({
				            mode: CBC,
				            padding: Pkcs7
				        }),

				        reset: function () {
				            // Reset cipher
				            Cipher.reset.call(this);

				            // Shortcuts
				            var cfg = this.cfg;
				            var iv = cfg.iv;
				            var mode = cfg.mode;

				            // Reset block mode
				            if (this._xformMode == this._ENC_XFORM_MODE) {
				                var modeCreator = mode.createEncryptor;
				            } else /* if (this._xformMode == this._DEC_XFORM_MODE) */ {
				                var modeCreator = mode.createDecryptor;
				                // Keep at least one block in the buffer for unpadding
				                this._minBufferSize = 1;
				            }

				            if (this._mode && this._mode.__creator == modeCreator) {
				                this._mode.init(this, iv && iv.words);
				            } else {
				                this._mode = modeCreator.call(mode, this, iv && iv.words);
				                this._mode.__creator = modeCreator;
				            }
				        },

				        _doProcessBlock: function (words, offset) {
				            this._mode.processBlock(words, offset);
				        },

				        _doFinalize: function () {
				            // Shortcut
				            var padding = this.cfg.padding;

				            // Finalize
				            if (this._xformMode == this._ENC_XFORM_MODE) {
				                // Pad data
				                padding.pad(this._data, this.blockSize);

				                // Process final blocks
				                var finalProcessedBlocks = this._process(!!'flush');
				            } else /* if (this._xformMode == this._DEC_XFORM_MODE) */ {
				                // Process final blocks
				                var finalProcessedBlocks = this._process(!!'flush');

				                // Unpad data
				                padding.unpad(finalProcessedBlocks);
				            }

				            return finalProcessedBlocks;
				        },

				        blockSize: 128/32
				    });

				    /**
				     * A collection of cipher parameters.
				     *
				     * @property {WordArray} ciphertext The raw ciphertext.
				     * @property {WordArray} key The key to this ciphertext.
				     * @property {WordArray} iv The IV used in the ciphering operation.
				     * @property {WordArray} salt The salt used with a key derivation function.
				     * @property {Cipher} algorithm The cipher algorithm.
				     * @property {Mode} mode The block mode used in the ciphering operation.
				     * @property {Padding} padding The padding scheme used in the ciphering operation.
				     * @property {number} blockSize The block size of the cipher.
				     * @property {Format} formatter The default formatting strategy to convert this cipher params object to a string.
				     */
				    var CipherParams = C_lib.CipherParams = Base.extend({
				        /**
				         * Initializes a newly created cipher params object.
				         *
				         * @param {Object} cipherParams An object with any of the possible cipher parameters.
				         *
				         * @example
				         *
				         *     var cipherParams = CryptoJS.lib.CipherParams.create({
				         *         ciphertext: ciphertextWordArray,
				         *         key: keyWordArray,
				         *         iv: ivWordArray,
				         *         salt: saltWordArray,
				         *         algorithm: CryptoJS.algo.AES,
				         *         mode: CryptoJS.mode.CBC,
				         *         padding: CryptoJS.pad.PKCS7,
				         *         blockSize: 4,
				         *         formatter: CryptoJS.format.OpenSSL
				         *     });
				         */
				        init: function (cipherParams) {
				            this.mixIn(cipherParams);
				        },

				        /**
				         * Converts this cipher params object to a string.
				         *
				         * @param {Format} formatter (Optional) The formatting strategy to use.
				         *
				         * @return {string} The stringified cipher params.
				         *
				         * @throws Error If neither the formatter nor the default formatter is set.
				         *
				         * @example
				         *
				         *     var string = cipherParams + '';
				         *     var string = cipherParams.toString();
				         *     var string = cipherParams.toString(CryptoJS.format.OpenSSL);
				         */
				        toString: function (formatter) {
				            return (formatter || this.formatter).stringify(this);
				        }
				    });

				    /**
				     * Format namespace.
				     */
				    var C_format = C.format = {};

				    /**
				     * OpenSSL formatting strategy.
				     */
				    var OpenSSLFormatter = C_format.OpenSSL = {
				        /**
				         * Converts a cipher params object to an OpenSSL-compatible string.
				         *
				         * @param {CipherParams} cipherParams The cipher params object.
				         *
				         * @return {string} The OpenSSL-compatible string.
				         *
				         * @static
				         *
				         * @example
				         *
				         *     var openSSLString = CryptoJS.format.OpenSSL.stringify(cipherParams);
				         */
				        stringify: function (cipherParams) {
				            // Shortcuts
				            var ciphertext = cipherParams.ciphertext;
				            var salt = cipherParams.salt;

				            // Format
				            if (salt) {
				                var wordArray = WordArray.create([0x53616c74, 0x65645f5f]).concat(salt).concat(ciphertext);
				            } else {
				                var wordArray = ciphertext;
				            }

				            return wordArray.toString(Base64);
				        },

				        /**
				         * Converts an OpenSSL-compatible string to a cipher params object.
				         *
				         * @param {string} openSSLStr The OpenSSL-compatible string.
				         *
				         * @return {CipherParams} The cipher params object.
				         *
				         * @static
				         *
				         * @example
				         *
				         *     var cipherParams = CryptoJS.format.OpenSSL.parse(openSSLString);
				         */
				        parse: function (openSSLStr) {
				            // Parse base64
				            var ciphertext = Base64.parse(openSSLStr);

				            // Shortcut
				            var ciphertextWords = ciphertext.words;

				            // Test for salt
				            if (ciphertextWords[0] == 0x53616c74 && ciphertextWords[1] == 0x65645f5f) {
				                // Extract salt
				                var salt = WordArray.create(ciphertextWords.slice(2, 4));

				                // Remove salt from ciphertext
				                ciphertextWords.splice(0, 4);
				                ciphertext.sigBytes -= 16;
				            }

				            return CipherParams.create({ ciphertext: ciphertext, salt: salt });
				        }
				    };

				    /**
				     * A cipher wrapper that returns ciphertext as a serializable cipher params object.
				     */
				    var SerializableCipher = C_lib.SerializableCipher = Base.extend({
				        /**
				         * Configuration options.
				         *
				         * @property {Formatter} format The formatting strategy to convert cipher param objects to and from a string. Default: OpenSSL
				         */
				        cfg: Base.extend({
				            format: OpenSSLFormatter
				        }),

				        /**
				         * Encrypts a message.
				         *
				         * @param {Cipher} cipher The cipher algorithm to use.
				         * @param {WordArray|string} message The message to encrypt.
				         * @param {WordArray} key The key.
				         * @param {Object} cfg (Optional) The configuration options to use for this operation.
				         *
				         * @return {CipherParams} A cipher params object.
				         *
				         * @static
				         *
				         * @example
				         *
				         *     var ciphertextParams = CryptoJS.lib.SerializableCipher.encrypt(CryptoJS.algo.AES, message, key);
				         *     var ciphertextParams = CryptoJS.lib.SerializableCipher.encrypt(CryptoJS.algo.AES, message, key, { iv: iv });
				         *     var ciphertextParams = CryptoJS.lib.SerializableCipher.encrypt(CryptoJS.algo.AES, message, key, { iv: iv, format: CryptoJS.format.OpenSSL });
				         */
				        encrypt: function (cipher, message, key, cfg) {
				            // Apply config defaults
				            cfg = this.cfg.extend(cfg);

				            // Encrypt
				            var encryptor = cipher.createEncryptor(key, cfg);
				            var ciphertext = encryptor.finalize(message);

				            // Shortcut
				            var cipherCfg = encryptor.cfg;

				            // Create and return serializable cipher params
				            return CipherParams.create({
				                ciphertext: ciphertext,
				                key: key,
				                iv: cipherCfg.iv,
				                algorithm: cipher,
				                mode: cipherCfg.mode,
				                padding: cipherCfg.padding,
				                blockSize: cipher.blockSize,
				                formatter: cfg.format
				            });
				        },

				        /**
				         * Decrypts serialized ciphertext.
				         *
				         * @param {Cipher} cipher The cipher algorithm to use.
				         * @param {CipherParams|string} ciphertext The ciphertext to decrypt.
				         * @param {WordArray} key The key.
				         * @param {Object} cfg (Optional) The configuration options to use for this operation.
				         *
				         * @return {WordArray} The plaintext.
				         *
				         * @static
				         *
				         * @example
				         *
				         *     var plaintext = CryptoJS.lib.SerializableCipher.decrypt(CryptoJS.algo.AES, formattedCiphertext, key, { iv: iv, format: CryptoJS.format.OpenSSL });
				         *     var plaintext = CryptoJS.lib.SerializableCipher.decrypt(CryptoJS.algo.AES, ciphertextParams, key, { iv: iv, format: CryptoJS.format.OpenSSL });
				         */
				        decrypt: function (cipher, ciphertext, key, cfg) {
				            // Apply config defaults
				            cfg = this.cfg.extend(cfg);

				            // Convert string to CipherParams
				            ciphertext = this._parse(ciphertext, cfg.format);

				            // Decrypt
				            var plaintext = cipher.createDecryptor(key, cfg).finalize(ciphertext.ciphertext);

				            return plaintext;
				        },

				        /**
				         * Converts serialized ciphertext to CipherParams,
				         * else assumed CipherParams already and returns ciphertext unchanged.
				         *
				         * @param {CipherParams|string} ciphertext The ciphertext.
				         * @param {Formatter} format The formatting strategy to use to parse serialized ciphertext.
				         *
				         * @return {CipherParams} The unserialized ciphertext.
				         *
				         * @static
				         *
				         * @example
				         *
				         *     var ciphertextParams = CryptoJS.lib.SerializableCipher._parse(ciphertextStringOrParams, format);
				         */
				        _parse: function (ciphertext, format) {
				            if (typeof ciphertext == 'string') {
				                return format.parse(ciphertext, this);
				            } else {
				                return ciphertext;
				            }
				        }
				    });

				    /**
				     * Key derivation function namespace.
				     */
				    var C_kdf = C.kdf = {};

				    /**
				     * OpenSSL key derivation function.
				     */
				    var OpenSSLKdf = C_kdf.OpenSSL = {
				        /**
				         * Derives a key and IV from a password.
				         *
				         * @param {string} password The password to derive from.
				         * @param {number} keySize The size in words of the key to generate.
				         * @param {number} ivSize The size in words of the IV to generate.
				         * @param {WordArray|string} salt (Optional) A 64-bit salt to use. If omitted, a salt will be generated randomly.
				         *
				         * @return {CipherParams} A cipher params object with the key, IV, and salt.
				         *
				         * @static
				         *
				         * @example
				         *
				         *     var derivedParams = CryptoJS.kdf.OpenSSL.execute('Password', 256/32, 128/32);
				         *     var derivedParams = CryptoJS.kdf.OpenSSL.execute('Password', 256/32, 128/32, 'saltsalt');
				         */
				        execute: function (password, keySize, ivSize, salt) {
				            // Generate random salt
				            if (!salt) {
				                salt = WordArray.random(64/8);
				            }

				            // Derive key and IV
				            var key = EvpKDF.create({ keySize: keySize + ivSize }).compute(password, salt);

				            // Separate key and IV
				            var iv = WordArray.create(key.words.slice(keySize), ivSize * 4);
				            key.sigBytes = keySize * 4;

				            // Return params
				            return CipherParams.create({ key: key, iv: iv, salt: salt });
				        }
				    };

				    /**
				     * A serializable cipher wrapper that derives the key from a password,
				     * and returns ciphertext as a serializable cipher params object.
				     */
				    var PasswordBasedCipher = C_lib.PasswordBasedCipher = SerializableCipher.extend({
				        /**
				         * Configuration options.
				         *
				         * @property {KDF} kdf The key derivation function to use to generate a key and IV from a password. Default: OpenSSL
				         */
				        cfg: SerializableCipher.cfg.extend({
				            kdf: OpenSSLKdf
				        }),

				        /**
				         * Encrypts a message using a password.
				         *
				         * @param {Cipher} cipher The cipher algorithm to use.
				         * @param {WordArray|string} message The message to encrypt.
				         * @param {string} password The password.
				         * @param {Object} cfg (Optional) The configuration options to use for this operation.
				         *
				         * @return {CipherParams} A cipher params object.
				         *
				         * @static
				         *
				         * @example
				         *
				         *     var ciphertextParams = CryptoJS.lib.PasswordBasedCipher.encrypt(CryptoJS.algo.AES, message, 'password');
				         *     var ciphertextParams = CryptoJS.lib.PasswordBasedCipher.encrypt(CryptoJS.algo.AES, message, 'password', { format: CryptoJS.format.OpenSSL });
				         */
				        encrypt: function (cipher, message, password, cfg) {
				            // Apply config defaults
				            cfg = this.cfg.extend(cfg);

				            // Derive key and other params
				            var derivedParams = cfg.kdf.execute(password, cipher.keySize, cipher.ivSize);

				            // Add IV to config
				            cfg.iv = derivedParams.iv;

				            // Encrypt
				            var ciphertext = SerializableCipher.encrypt.call(this, cipher, message, derivedParams.key, cfg);

				            // Mix in derived params
				            ciphertext.mixIn(derivedParams);

				            return ciphertext;
				        },

				        /**
				         * Decrypts serialized ciphertext using a password.
				         *
				         * @param {Cipher} cipher The cipher algorithm to use.
				         * @param {CipherParams|string} ciphertext The ciphertext to decrypt.
				         * @param {string} password The password.
				         * @param {Object} cfg (Optional) The configuration options to use for this operation.
				         *
				         * @return {WordArray} The plaintext.
				         *
				         * @static
				         *
				         * @example
				         *
				         *     var plaintext = CryptoJS.lib.PasswordBasedCipher.decrypt(CryptoJS.algo.AES, formattedCiphertext, 'password', { format: CryptoJS.format.OpenSSL });
				         *     var plaintext = CryptoJS.lib.PasswordBasedCipher.decrypt(CryptoJS.algo.AES, ciphertextParams, 'password', { format: CryptoJS.format.OpenSSL });
				         */
				        decrypt: function (cipher, ciphertext, password, cfg) {
				            // Apply config defaults
				            cfg = this.cfg.extend(cfg);

				            // Convert string to CipherParams
				            ciphertext = this._parse(ciphertext, cfg.format);

				            // Derive key and other params
				            var derivedParams = cfg.kdf.execute(password, cipher.keySize, cipher.ivSize, ciphertext.salt);

				            // Add IV to config
				            cfg.iv = derivedParams.iv;

				            // Decrypt
				            var plaintext = SerializableCipher.decrypt.call(this, cipher, ciphertext, derivedParams.key, cfg);

				            return plaintext;
				        }
				    });
				}());


			}));
		} (cipherCore));
		return cipherCore.exports;
	}

	var modeCfb = {exports: {}};

	var hasRequiredModeCfb;

	function requireModeCfb () {
		if (hasRequiredModeCfb) return modeCfb.exports;
		hasRequiredModeCfb = 1;
		(function (module, exports) {
	(function (root, factory, undef) {
				{
					// CommonJS
					module.exports = factory(requireCore(), requireCipherCore());
				}
			}(commonjsGlobal, function (CryptoJS) {

				/**
				 * Cipher Feedback block mode.
				 */
				CryptoJS.mode.CFB = (function () {
				    var CFB = CryptoJS.lib.BlockCipherMode.extend();

				    CFB.Encryptor = CFB.extend({
				        processBlock: function (words, offset) {
				            // Shortcuts
				            var cipher = this._cipher;
				            var blockSize = cipher.blockSize;

				            generateKeystreamAndEncrypt.call(this, words, offset, blockSize, cipher);

				            // Remember this block to use with next block
				            this._prevBlock = words.slice(offset, offset + blockSize);
				        }
				    });

				    CFB.Decryptor = CFB.extend({
				        processBlock: function (words, offset) {
				            // Shortcuts
				            var cipher = this._cipher;
				            var blockSize = cipher.blockSize;

				            // Remember this block to use with next block
				            var thisBlock = words.slice(offset, offset + blockSize);

				            generateKeystreamAndEncrypt.call(this, words, offset, blockSize, cipher);

				            // This block becomes the previous block
				            this._prevBlock = thisBlock;
				        }
				    });

				    function generateKeystreamAndEncrypt(words, offset, blockSize, cipher) {
				        // Shortcut
				        var iv = this._iv;

				        // Generate keystream
				        if (iv) {
				            var keystream = iv.slice(0);

				            // Remove IV for subsequent blocks
				            this._iv = undefined;
				        } else {
				            var keystream = this._prevBlock;
				        }
				        cipher.encryptBlock(keystream, 0);

				        // Encrypt
				        for (var i = 0; i < blockSize; i++) {
				            words[offset + i] ^= keystream[i];
				        }
				    }

				    return CFB;
				}());


				return CryptoJS.mode.CFB;

			}));
		} (modeCfb));
		return modeCfb.exports;
	}

	var modeCtr = {exports: {}};

	var hasRequiredModeCtr;

	function requireModeCtr () {
		if (hasRequiredModeCtr) return modeCtr.exports;
		hasRequiredModeCtr = 1;
		(function (module, exports) {
	(function (root, factory, undef) {
				{
					// CommonJS
					module.exports = factory(requireCore(), requireCipherCore());
				}
			}(commonjsGlobal, function (CryptoJS) {

				/**
				 * Counter block mode.
				 */
				CryptoJS.mode.CTR = (function () {
				    var CTR = CryptoJS.lib.BlockCipherMode.extend();

				    var Encryptor = CTR.Encryptor = CTR.extend({
				        processBlock: function (words, offset) {
				            // Shortcuts
				            var cipher = this._cipher;
				            var blockSize = cipher.blockSize;
				            var iv = this._iv;
				            var counter = this._counter;

				            // Generate keystream
				            if (iv) {
				                counter = this._counter = iv.slice(0);

				                // Remove IV for subsequent blocks
				                this._iv = undefined;
				            }
				            var keystream = counter.slice(0);
				            cipher.encryptBlock(keystream, 0);

				            // Increment counter
				            counter[blockSize - 1] = (counter[blockSize - 1] + 1) | 0;

				            // Encrypt
				            for (var i = 0; i < blockSize; i++) {
				                words[offset + i] ^= keystream[i];
				            }
				        }
				    });

				    CTR.Decryptor = Encryptor;

				    return CTR;
				}());


				return CryptoJS.mode.CTR;

			}));
		} (modeCtr));
		return modeCtr.exports;
	}

	var modeCtrGladman = {exports: {}};

	var hasRequiredModeCtrGladman;

	function requireModeCtrGladman () {
		if (hasRequiredModeCtrGladman) return modeCtrGladman.exports;
		hasRequiredModeCtrGladman = 1;
		(function (module, exports) {
	(function (root, factory, undef) {
				{
					// CommonJS
					module.exports = factory(requireCore(), requireCipherCore());
				}
			}(commonjsGlobal, function (CryptoJS) {

				/** @preserve
				 * Counter block mode compatible with  Dr Brian Gladman fileenc.c
				 * derived from CryptoJS.mode.CTR
				 * Jan Hruby jhruby.web@gmail.com
				 */
				CryptoJS.mode.CTRGladman = (function () {
				    var CTRGladman = CryptoJS.lib.BlockCipherMode.extend();

					function incWord(word)
					{
						if (((word >> 24) & 0xff) === 0xff) { //overflow
						var b1 = (word >> 16)&0xff;
						var b2 = (word >> 8)&0xff;
						var b3 = word & 0xff;

						if (b1 === 0xff) // overflow b1
						{
						b1 = 0;
						if (b2 === 0xff)
						{
							b2 = 0;
							if (b3 === 0xff)
							{
								b3 = 0;
							}
							else
							{
								++b3;
							}
						}
						else
						{
							++b2;
						}
						}
						else
						{
						++b1;
						}

						word = 0;
						word += (b1 << 16);
						word += (b2 << 8);
						word += b3;
						}
						else
						{
						word += (0x01 << 24);
						}
						return word;
					}

					function incCounter(counter)
					{
						if ((counter[0] = incWord(counter[0])) === 0)
						{
							// encr_data in fileenc.c from  Dr Brian Gladman's counts only with DWORD j < 8
							counter[1] = incWord(counter[1]);
						}
						return counter;
					}

				    var Encryptor = CTRGladman.Encryptor = CTRGladman.extend({
				        processBlock: function (words, offset) {
				            // Shortcuts
				            var cipher = this._cipher;
				            var blockSize = cipher.blockSize;
				            var iv = this._iv;
				            var counter = this._counter;

				            // Generate keystream
				            if (iv) {
				                counter = this._counter = iv.slice(0);

				                // Remove IV for subsequent blocks
				                this._iv = undefined;
				            }

							incCounter(counter);

							var keystream = counter.slice(0);
				            cipher.encryptBlock(keystream, 0);

				            // Encrypt
				            for (var i = 0; i < blockSize; i++) {
				                words[offset + i] ^= keystream[i];
				            }
				        }
				    });

				    CTRGladman.Decryptor = Encryptor;

				    return CTRGladman;
				}());




				return CryptoJS.mode.CTRGladman;

			}));
		} (modeCtrGladman));
		return modeCtrGladman.exports;
	}

	var modeOfb = {exports: {}};

	var hasRequiredModeOfb;

	function requireModeOfb () {
		if (hasRequiredModeOfb) return modeOfb.exports;
		hasRequiredModeOfb = 1;
		(function (module, exports) {
	(function (root, factory, undef) {
				{
					// CommonJS
					module.exports = factory(requireCore(), requireCipherCore());
				}
			}(commonjsGlobal, function (CryptoJS) {

				/**
				 * Output Feedback block mode.
				 */
				CryptoJS.mode.OFB = (function () {
				    var OFB = CryptoJS.lib.BlockCipherMode.extend();

				    var Encryptor = OFB.Encryptor = OFB.extend({
				        processBlock: function (words, offset) {
				            // Shortcuts
				            var cipher = this._cipher;
				            var blockSize = cipher.blockSize;
				            var iv = this._iv;
				            var keystream = this._keystream;

				            // Generate keystream
				            if (iv) {
				                keystream = this._keystream = iv.slice(0);

				                // Remove IV for subsequent blocks
				                this._iv = undefined;
				            }
				            cipher.encryptBlock(keystream, 0);

				            // Encrypt
				            for (var i = 0; i < blockSize; i++) {
				                words[offset + i] ^= keystream[i];
				            }
				        }
				    });

				    OFB.Decryptor = Encryptor;

				    return OFB;
				}());


				return CryptoJS.mode.OFB;

			}));
		} (modeOfb));
		return modeOfb.exports;
	}

	var modeEcb = {exports: {}};

	var hasRequiredModeEcb;

	function requireModeEcb () {
		if (hasRequiredModeEcb) return modeEcb.exports;
		hasRequiredModeEcb = 1;
		(function (module, exports) {
	(function (root, factory, undef) {
				{
					// CommonJS
					module.exports = factory(requireCore(), requireCipherCore());
				}
			}(commonjsGlobal, function (CryptoJS) {

				/**
				 * Electronic Codebook block mode.
				 */
				CryptoJS.mode.ECB = (function () {
				    var ECB = CryptoJS.lib.BlockCipherMode.extend();

				    ECB.Encryptor = ECB.extend({
				        processBlock: function (words, offset) {
				            this._cipher.encryptBlock(words, offset);
				        }
				    });

				    ECB.Decryptor = ECB.extend({
				        processBlock: function (words, offset) {
				            this._cipher.decryptBlock(words, offset);
				        }
				    });

				    return ECB;
				}());


				return CryptoJS.mode.ECB;

			}));
		} (modeEcb));
		return modeEcb.exports;
	}

	var padAnsix923 = {exports: {}};

	var hasRequiredPadAnsix923;

	function requirePadAnsix923 () {
		if (hasRequiredPadAnsix923) return padAnsix923.exports;
		hasRequiredPadAnsix923 = 1;
		(function (module, exports) {
	(function (root, factory, undef) {
				{
					// CommonJS
					module.exports = factory(requireCore(), requireCipherCore());
				}
			}(commonjsGlobal, function (CryptoJS) {

				/**
				 * ANSI X.923 padding strategy.
				 */
				CryptoJS.pad.AnsiX923 = {
				    pad: function (data, blockSize) {
				        // Shortcuts
				        var dataSigBytes = data.sigBytes;
				        var blockSizeBytes = blockSize * 4;

				        // Count padding bytes
				        var nPaddingBytes = blockSizeBytes - dataSigBytes % blockSizeBytes;

				        // Compute last byte position
				        var lastBytePos = dataSigBytes + nPaddingBytes - 1;

				        // Pad
				        data.clamp();
				        data.words[lastBytePos >>> 2] |= nPaddingBytes << (24 - (lastBytePos % 4) * 8);
				        data.sigBytes += nPaddingBytes;
				    },

				    unpad: function (data) {
				        // Get number of padding bytes from last byte
				        var nPaddingBytes = data.words[(data.sigBytes - 1) >>> 2] & 0xff;

				        // Remove padding
				        data.sigBytes -= nPaddingBytes;
				    }
				};


				return CryptoJS.pad.Ansix923;

			}));
		} (padAnsix923));
		return padAnsix923.exports;
	}

	var padIso10126 = {exports: {}};

	var hasRequiredPadIso10126;

	function requirePadIso10126 () {
		if (hasRequiredPadIso10126) return padIso10126.exports;
		hasRequiredPadIso10126 = 1;
		(function (module, exports) {
	(function (root, factory, undef) {
				{
					// CommonJS
					module.exports = factory(requireCore(), requireCipherCore());
				}
			}(commonjsGlobal, function (CryptoJS) {

				/**
				 * ISO 10126 padding strategy.
				 */
				CryptoJS.pad.Iso10126 = {
				    pad: function (data, blockSize) {
				        // Shortcut
				        var blockSizeBytes = blockSize * 4;

				        // Count padding bytes
				        var nPaddingBytes = blockSizeBytes - data.sigBytes % blockSizeBytes;

				        // Pad
				        data.concat(CryptoJS.lib.WordArray.random(nPaddingBytes - 1)).
				             concat(CryptoJS.lib.WordArray.create([nPaddingBytes << 24], 1));
				    },

				    unpad: function (data) {
				        // Get number of padding bytes from last byte
				        var nPaddingBytes = data.words[(data.sigBytes - 1) >>> 2] & 0xff;

				        // Remove padding
				        data.sigBytes -= nPaddingBytes;
				    }
				};


				return CryptoJS.pad.Iso10126;

			}));
		} (padIso10126));
		return padIso10126.exports;
	}

	var padIso97971 = {exports: {}};

	var hasRequiredPadIso97971;

	function requirePadIso97971 () {
		if (hasRequiredPadIso97971) return padIso97971.exports;
		hasRequiredPadIso97971 = 1;
		(function (module, exports) {
	(function (root, factory, undef) {
				{
					// CommonJS
					module.exports = factory(requireCore(), requireCipherCore());
				}
			}(commonjsGlobal, function (CryptoJS) {

				/**
				 * ISO/IEC 9797-1 Padding Method 2.
				 */
				CryptoJS.pad.Iso97971 = {
				    pad: function (data, blockSize) {
				        // Add 0x80 byte
				        data.concat(CryptoJS.lib.WordArray.create([0x80000000], 1));

				        // Zero pad the rest
				        CryptoJS.pad.ZeroPadding.pad(data, blockSize);
				    },

				    unpad: function (data) {
				        // Remove zero padding
				        CryptoJS.pad.ZeroPadding.unpad(data);

				        // Remove one more byte -- the 0x80 byte
				        data.sigBytes--;
				    }
				};


				return CryptoJS.pad.Iso97971;

			}));
		} (padIso97971));
		return padIso97971.exports;
	}

	var padZeropadding = {exports: {}};

	var hasRequiredPadZeropadding;

	function requirePadZeropadding () {
		if (hasRequiredPadZeropadding) return padZeropadding.exports;
		hasRequiredPadZeropadding = 1;
		(function (module, exports) {
	(function (root, factory, undef) {
				{
					// CommonJS
					module.exports = factory(requireCore(), requireCipherCore());
				}
			}(commonjsGlobal, function (CryptoJS) {

				/**
				 * Zero padding strategy.
				 */
				CryptoJS.pad.ZeroPadding = {
				    pad: function (data, blockSize) {
				        // Shortcut
				        var blockSizeBytes = blockSize * 4;

				        // Pad
				        data.clamp();
				        data.sigBytes += blockSizeBytes - ((data.sigBytes % blockSizeBytes) || blockSizeBytes);
				    },

				    unpad: function (data) {
				        // Shortcut
				        var dataWords = data.words;

				        // Unpad
				        var i = data.sigBytes - 1;
				        while (!((dataWords[i >>> 2] >>> (24 - (i % 4) * 8)) & 0xff)) {
				            i--;
				        }
				        data.sigBytes = i + 1;
				    }
				};


				return CryptoJS.pad.ZeroPadding;

			}));
		} (padZeropadding));
		return padZeropadding.exports;
	}

	var padNopadding = {exports: {}};

	var hasRequiredPadNopadding;

	function requirePadNopadding () {
		if (hasRequiredPadNopadding) return padNopadding.exports;
		hasRequiredPadNopadding = 1;
		(function (module, exports) {
	(function (root, factory, undef) {
				{
					// CommonJS
					module.exports = factory(requireCore(), requireCipherCore());
				}
			}(commonjsGlobal, function (CryptoJS) {

				/**
				 * A noop padding strategy.
				 */
				CryptoJS.pad.NoPadding = {
				    pad: function () {
				    },

				    unpad: function () {
				    }
				};


				return CryptoJS.pad.NoPadding;

			}));
		} (padNopadding));
		return padNopadding.exports;
	}

	var formatHex = {exports: {}};

	var hasRequiredFormatHex;

	function requireFormatHex () {
		if (hasRequiredFormatHex) return formatHex.exports;
		hasRequiredFormatHex = 1;
		(function (module, exports) {
	(function (root, factory, undef) {
				{
					// CommonJS
					module.exports = factory(requireCore(), requireCipherCore());
				}
			}(commonjsGlobal, function (CryptoJS) {

				(function (undefined$1) {
				    // Shortcuts
				    var C = CryptoJS;
				    var C_lib = C.lib;
				    var CipherParams = C_lib.CipherParams;
				    var C_enc = C.enc;
				    var Hex = C_enc.Hex;
				    var C_format = C.format;

				    C_format.Hex = {
				        /**
				         * Converts the ciphertext of a cipher params object to a hexadecimally encoded string.
				         *
				         * @param {CipherParams} cipherParams The cipher params object.
				         *
				         * @return {string} The hexadecimally encoded string.
				         *
				         * @static
				         *
				         * @example
				         *
				         *     var hexString = CryptoJS.format.Hex.stringify(cipherParams);
				         */
				        stringify: function (cipherParams) {
				            return cipherParams.ciphertext.toString(Hex);
				        },

				        /**
				         * Converts a hexadecimally encoded ciphertext string to a cipher params object.
				         *
				         * @param {string} input The hexadecimally encoded string.
				         *
				         * @return {CipherParams} The cipher params object.
				         *
				         * @static
				         *
				         * @example
				         *
				         *     var cipherParams = CryptoJS.format.Hex.parse(hexString);
				         */
				        parse: function (input) {
				            var ciphertext = Hex.parse(input);
				            return CipherParams.create({ ciphertext: ciphertext });
				        }
				    };
				}());


				return CryptoJS.format.Hex;

			}));
		} (formatHex));
		return formatHex.exports;
	}

	var aes = {exports: {}};

	var hasRequiredAes;

	function requireAes () {
		if (hasRequiredAes) return aes.exports;
		hasRequiredAes = 1;
		(function (module, exports) {
	(function (root, factory, undef) {
				{
					// CommonJS
					module.exports = factory(requireCore(), requireEncBase64(), requireMd5(), requireEvpkdf(), requireCipherCore());
				}
			}(commonjsGlobal, function (CryptoJS) {

				(function () {
				    // Shortcuts
				    var C = CryptoJS;
				    var C_lib = C.lib;
				    var BlockCipher = C_lib.BlockCipher;
				    var C_algo = C.algo;

				    // Lookup tables
				    var SBOX = [];
				    var INV_SBOX = [];
				    var SUB_MIX_0 = [];
				    var SUB_MIX_1 = [];
				    var SUB_MIX_2 = [];
				    var SUB_MIX_3 = [];
				    var INV_SUB_MIX_0 = [];
				    var INV_SUB_MIX_1 = [];
				    var INV_SUB_MIX_2 = [];
				    var INV_SUB_MIX_3 = [];

				    // Compute lookup tables
				    (function () {
				        // Compute double table
				        var d = [];
				        for (var i = 0; i < 256; i++) {
				            if (i < 128) {
				                d[i] = i << 1;
				            } else {
				                d[i] = (i << 1) ^ 0x11b;
				            }
				        }

				        // Walk GF(2^8)
				        var x = 0;
				        var xi = 0;
				        for (var i = 0; i < 256; i++) {
				            // Compute sbox
				            var sx = xi ^ (xi << 1) ^ (xi << 2) ^ (xi << 3) ^ (xi << 4);
				            sx = (sx >>> 8) ^ (sx & 0xff) ^ 0x63;
				            SBOX[x] = sx;
				            INV_SBOX[sx] = x;

				            // Compute multiplication
				            var x2 = d[x];
				            var x4 = d[x2];
				            var x8 = d[x4];

				            // Compute sub bytes, mix columns tables
				            var t = (d[sx] * 0x101) ^ (sx * 0x1010100);
				            SUB_MIX_0[x] = (t << 24) | (t >>> 8);
				            SUB_MIX_1[x] = (t << 16) | (t >>> 16);
				            SUB_MIX_2[x] = (t << 8)  | (t >>> 24);
				            SUB_MIX_3[x] = t;

				            // Compute inv sub bytes, inv mix columns tables
				            var t = (x8 * 0x1010101) ^ (x4 * 0x10001) ^ (x2 * 0x101) ^ (x * 0x1010100);
				            INV_SUB_MIX_0[sx] = (t << 24) | (t >>> 8);
				            INV_SUB_MIX_1[sx] = (t << 16) | (t >>> 16);
				            INV_SUB_MIX_2[sx] = (t << 8)  | (t >>> 24);
				            INV_SUB_MIX_3[sx] = t;

				            // Compute next counter
				            if (!x) {
				                x = xi = 1;
				            } else {
				                x = x2 ^ d[d[d[x8 ^ x2]]];
				                xi ^= d[d[xi]];
				            }
				        }
				    }());

				    // Precomputed Rcon lookup
				    var RCON = [0x00, 0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80, 0x1b, 0x36];

				    /**
				     * AES block cipher algorithm.
				     */
				    var AES = C_algo.AES = BlockCipher.extend({
				        _doReset: function () {
				            // Skip reset of nRounds has been set before and key did not change
				            if (this._nRounds && this._keyPriorReset === this._key) {
				                return;
				            }

				            // Shortcuts
				            var key = this._keyPriorReset = this._key;
				            var keyWords = key.words;
				            var keySize = key.sigBytes / 4;

				            // Compute number of rounds
				            var nRounds = this._nRounds = keySize + 6;

				            // Compute number of key schedule rows
				            var ksRows = (nRounds + 1) * 4;

				            // Compute key schedule
				            var keySchedule = this._keySchedule = [];
				            for (var ksRow = 0; ksRow < ksRows; ksRow++) {
				                if (ksRow < keySize) {
				                    keySchedule[ksRow] = keyWords[ksRow];
				                } else {
				                    var t = keySchedule[ksRow - 1];

				                    if (!(ksRow % keySize)) {
				                        // Rot word
				                        t = (t << 8) | (t >>> 24);

				                        // Sub word
				                        t = (SBOX[t >>> 24] << 24) | (SBOX[(t >>> 16) & 0xff] << 16) | (SBOX[(t >>> 8) & 0xff] << 8) | SBOX[t & 0xff];

				                        // Mix Rcon
				                        t ^= RCON[(ksRow / keySize) | 0] << 24;
				                    } else if (keySize > 6 && ksRow % keySize == 4) {
				                        // Sub word
				                        t = (SBOX[t >>> 24] << 24) | (SBOX[(t >>> 16) & 0xff] << 16) | (SBOX[(t >>> 8) & 0xff] << 8) | SBOX[t & 0xff];
				                    }

				                    keySchedule[ksRow] = keySchedule[ksRow - keySize] ^ t;
				                }
				            }

				            // Compute inv key schedule
				            var invKeySchedule = this._invKeySchedule = [];
				            for (var invKsRow = 0; invKsRow < ksRows; invKsRow++) {
				                var ksRow = ksRows - invKsRow;

				                if (invKsRow % 4) {
				                    var t = keySchedule[ksRow];
				                } else {
				                    var t = keySchedule[ksRow - 4];
				                }

				                if (invKsRow < 4 || ksRow <= 4) {
				                    invKeySchedule[invKsRow] = t;
				                } else {
				                    invKeySchedule[invKsRow] = INV_SUB_MIX_0[SBOX[t >>> 24]] ^ INV_SUB_MIX_1[SBOX[(t >>> 16) & 0xff]] ^
				                                               INV_SUB_MIX_2[SBOX[(t >>> 8) & 0xff]] ^ INV_SUB_MIX_3[SBOX[t & 0xff]];
				                }
				            }
				        },

				        encryptBlock: function (M, offset) {
				            this._doCryptBlock(M, offset, this._keySchedule, SUB_MIX_0, SUB_MIX_1, SUB_MIX_2, SUB_MIX_3, SBOX);
				        },

				        decryptBlock: function (M, offset) {
				            // Swap 2nd and 4th rows
				            var t = M[offset + 1];
				            M[offset + 1] = M[offset + 3];
				            M[offset + 3] = t;

				            this._doCryptBlock(M, offset, this._invKeySchedule, INV_SUB_MIX_0, INV_SUB_MIX_1, INV_SUB_MIX_2, INV_SUB_MIX_3, INV_SBOX);

				            // Inv swap 2nd and 4th rows
				            var t = M[offset + 1];
				            M[offset + 1] = M[offset + 3];
				            M[offset + 3] = t;
				        },

				        _doCryptBlock: function (M, offset, keySchedule, SUB_MIX_0, SUB_MIX_1, SUB_MIX_2, SUB_MIX_3, SBOX) {
				            // Shortcut
				            var nRounds = this._nRounds;

				            // Get input, add round key
				            var s0 = M[offset]     ^ keySchedule[0];
				            var s1 = M[offset + 1] ^ keySchedule[1];
				            var s2 = M[offset + 2] ^ keySchedule[2];
				            var s3 = M[offset + 3] ^ keySchedule[3];

				            // Key schedule row counter
				            var ksRow = 4;

				            // Rounds
				            for (var round = 1; round < nRounds; round++) {
				                // Shift rows, sub bytes, mix columns, add round key
				                var t0 = SUB_MIX_0[s0 >>> 24] ^ SUB_MIX_1[(s1 >>> 16) & 0xff] ^ SUB_MIX_2[(s2 >>> 8) & 0xff] ^ SUB_MIX_3[s3 & 0xff] ^ keySchedule[ksRow++];
				                var t1 = SUB_MIX_0[s1 >>> 24] ^ SUB_MIX_1[(s2 >>> 16) & 0xff] ^ SUB_MIX_2[(s3 >>> 8) & 0xff] ^ SUB_MIX_3[s0 & 0xff] ^ keySchedule[ksRow++];
				                var t2 = SUB_MIX_0[s2 >>> 24] ^ SUB_MIX_1[(s3 >>> 16) & 0xff] ^ SUB_MIX_2[(s0 >>> 8) & 0xff] ^ SUB_MIX_3[s1 & 0xff] ^ keySchedule[ksRow++];
				                var t3 = SUB_MIX_0[s3 >>> 24] ^ SUB_MIX_1[(s0 >>> 16) & 0xff] ^ SUB_MIX_2[(s1 >>> 8) & 0xff] ^ SUB_MIX_3[s2 & 0xff] ^ keySchedule[ksRow++];

				                // Update state
				                s0 = t0;
				                s1 = t1;
				                s2 = t2;
				                s3 = t3;
				            }

				            // Shift rows, sub bytes, add round key
				            var t0 = ((SBOX[s0 >>> 24] << 24) | (SBOX[(s1 >>> 16) & 0xff] << 16) | (SBOX[(s2 >>> 8) & 0xff] << 8) | SBOX[s3 & 0xff]) ^ keySchedule[ksRow++];
				            var t1 = ((SBOX[s1 >>> 24] << 24) | (SBOX[(s2 >>> 16) & 0xff] << 16) | (SBOX[(s3 >>> 8) & 0xff] << 8) | SBOX[s0 & 0xff]) ^ keySchedule[ksRow++];
				            var t2 = ((SBOX[s2 >>> 24] << 24) | (SBOX[(s3 >>> 16) & 0xff] << 16) | (SBOX[(s0 >>> 8) & 0xff] << 8) | SBOX[s1 & 0xff]) ^ keySchedule[ksRow++];
				            var t3 = ((SBOX[s3 >>> 24] << 24) | (SBOX[(s0 >>> 16) & 0xff] << 16) | (SBOX[(s1 >>> 8) & 0xff] << 8) | SBOX[s2 & 0xff]) ^ keySchedule[ksRow++];

				            // Set output
				            M[offset]     = t0;
				            M[offset + 1] = t1;
				            M[offset + 2] = t2;
				            M[offset + 3] = t3;
				        },

				        keySize: 256/32
				    });

				    /**
				     * Shortcut functions to the cipher's object interface.
				     *
				     * @example
				     *
				     *     var ciphertext = CryptoJS.AES.encrypt(message, key, cfg);
				     *     var plaintext  = CryptoJS.AES.decrypt(ciphertext, key, cfg);
				     */
				    C.AES = BlockCipher._createHelper(AES);
				}());


				return CryptoJS.AES;

			}));
		} (aes));
		return aes.exports;
	}

	var tripledes = {exports: {}};

	var hasRequiredTripledes;

	function requireTripledes () {
		if (hasRequiredTripledes) return tripledes.exports;
		hasRequiredTripledes = 1;
		(function (module, exports) {
	(function (root, factory, undef) {
				{
					// CommonJS
					module.exports = factory(requireCore(), requireEncBase64(), requireMd5(), requireEvpkdf(), requireCipherCore());
				}
			}(commonjsGlobal, function (CryptoJS) {

				(function () {
				    // Shortcuts
				    var C = CryptoJS;
				    var C_lib = C.lib;
				    var WordArray = C_lib.WordArray;
				    var BlockCipher = C_lib.BlockCipher;
				    var C_algo = C.algo;

				    // Permuted Choice 1 constants
				    var PC1 = [
				        57, 49, 41, 33, 25, 17, 9,  1,
				        58, 50, 42, 34, 26, 18, 10, 2,
				        59, 51, 43, 35, 27, 19, 11, 3,
				        60, 52, 44, 36, 63, 55, 47, 39,
				        31, 23, 15, 7,  62, 54, 46, 38,
				        30, 22, 14, 6,  61, 53, 45, 37,
				        29, 21, 13, 5,  28, 20, 12, 4
				    ];

				    // Permuted Choice 2 constants
				    var PC2 = [
				        14, 17, 11, 24, 1,  5,
				        3,  28, 15, 6,  21, 10,
				        23, 19, 12, 4,  26, 8,
				        16, 7,  27, 20, 13, 2,
				        41, 52, 31, 37, 47, 55,
				        30, 40, 51, 45, 33, 48,
				        44, 49, 39, 56, 34, 53,
				        46, 42, 50, 36, 29, 32
				    ];

				    // Cumulative bit shift constants
				    var BIT_SHIFTS = [1,  2,  4,  6,  8,  10, 12, 14, 15, 17, 19, 21, 23, 25, 27, 28];

				    // SBOXes and round permutation constants
				    var SBOX_P = [
				        {
				            0x0: 0x808200,
				            0x10000000: 0x8000,
				            0x20000000: 0x808002,
				            0x30000000: 0x2,
				            0x40000000: 0x200,
				            0x50000000: 0x808202,
				            0x60000000: 0x800202,
				            0x70000000: 0x800000,
				            0x80000000: 0x202,
				            0x90000000: 0x800200,
				            0xa0000000: 0x8200,
				            0xb0000000: 0x808000,
				            0xc0000000: 0x8002,
				            0xd0000000: 0x800002,
				            0xe0000000: 0x0,
				            0xf0000000: 0x8202,
				            0x8000000: 0x0,
				            0x18000000: 0x808202,
				            0x28000000: 0x8202,
				            0x38000000: 0x8000,
				            0x48000000: 0x808200,
				            0x58000000: 0x200,
				            0x68000000: 0x808002,
				            0x78000000: 0x2,
				            0x88000000: 0x800200,
				            0x98000000: 0x8200,
				            0xa8000000: 0x808000,
				            0xb8000000: 0x800202,
				            0xc8000000: 0x800002,
				            0xd8000000: 0x8002,
				            0xe8000000: 0x202,
				            0xf8000000: 0x800000,
				            0x1: 0x8000,
				            0x10000001: 0x2,
				            0x20000001: 0x808200,
				            0x30000001: 0x800000,
				            0x40000001: 0x808002,
				            0x50000001: 0x8200,
				            0x60000001: 0x200,
				            0x70000001: 0x800202,
				            0x80000001: 0x808202,
				            0x90000001: 0x808000,
				            0xa0000001: 0x800002,
				            0xb0000001: 0x8202,
				            0xc0000001: 0x202,
				            0xd0000001: 0x800200,
				            0xe0000001: 0x8002,
				            0xf0000001: 0x0,
				            0x8000001: 0x808202,
				            0x18000001: 0x808000,
				            0x28000001: 0x800000,
				            0x38000001: 0x200,
				            0x48000001: 0x8000,
				            0x58000001: 0x800002,
				            0x68000001: 0x2,
				            0x78000001: 0x8202,
				            0x88000001: 0x8002,
				            0x98000001: 0x800202,
				            0xa8000001: 0x202,
				            0xb8000001: 0x808200,
				            0xc8000001: 0x800200,
				            0xd8000001: 0x0,
				            0xe8000001: 0x8200,
				            0xf8000001: 0x808002
				        },
				        {
				            0x0: 0x40084010,
				            0x1000000: 0x4000,
				            0x2000000: 0x80000,
				            0x3000000: 0x40080010,
				            0x4000000: 0x40000010,
				            0x5000000: 0x40084000,
				            0x6000000: 0x40004000,
				            0x7000000: 0x10,
				            0x8000000: 0x84000,
				            0x9000000: 0x40004010,
				            0xa000000: 0x40000000,
				            0xb000000: 0x84010,
				            0xc000000: 0x80010,
				            0xd000000: 0x0,
				            0xe000000: 0x4010,
				            0xf000000: 0x40080000,
				            0x800000: 0x40004000,
				            0x1800000: 0x84010,
				            0x2800000: 0x10,
				            0x3800000: 0x40004010,
				            0x4800000: 0x40084010,
				            0x5800000: 0x40000000,
				            0x6800000: 0x80000,
				            0x7800000: 0x40080010,
				            0x8800000: 0x80010,
				            0x9800000: 0x0,
				            0xa800000: 0x4000,
				            0xb800000: 0x40080000,
				            0xc800000: 0x40000010,
				            0xd800000: 0x84000,
				            0xe800000: 0x40084000,
				            0xf800000: 0x4010,
				            0x10000000: 0x0,
				            0x11000000: 0x40080010,
				            0x12000000: 0x40004010,
				            0x13000000: 0x40084000,
				            0x14000000: 0x40080000,
				            0x15000000: 0x10,
				            0x16000000: 0x84010,
				            0x17000000: 0x4000,
				            0x18000000: 0x4010,
				            0x19000000: 0x80000,
				            0x1a000000: 0x80010,
				            0x1b000000: 0x40000010,
				            0x1c000000: 0x84000,
				            0x1d000000: 0x40004000,
				            0x1e000000: 0x40000000,
				            0x1f000000: 0x40084010,
				            0x10800000: 0x84010,
				            0x11800000: 0x80000,
				            0x12800000: 0x40080000,
				            0x13800000: 0x4000,
				            0x14800000: 0x40004000,
				            0x15800000: 0x40084010,
				            0x16800000: 0x10,
				            0x17800000: 0x40000000,
				            0x18800000: 0x40084000,
				            0x19800000: 0x40000010,
				            0x1a800000: 0x40004010,
				            0x1b800000: 0x80010,
				            0x1c800000: 0x0,
				            0x1d800000: 0x4010,
				            0x1e800000: 0x40080010,
				            0x1f800000: 0x84000
				        },
				        {
				            0x0: 0x104,
				            0x100000: 0x0,
				            0x200000: 0x4000100,
				            0x300000: 0x10104,
				            0x400000: 0x10004,
				            0x500000: 0x4000004,
				            0x600000: 0x4010104,
				            0x700000: 0x4010000,
				            0x800000: 0x4000000,
				            0x900000: 0x4010100,
				            0xa00000: 0x10100,
				            0xb00000: 0x4010004,
				            0xc00000: 0x4000104,
				            0xd00000: 0x10000,
				            0xe00000: 0x4,
				            0xf00000: 0x100,
				            0x80000: 0x4010100,
				            0x180000: 0x4010004,
				            0x280000: 0x0,
				            0x380000: 0x4000100,
				            0x480000: 0x4000004,
				            0x580000: 0x10000,
				            0x680000: 0x10004,
				            0x780000: 0x104,
				            0x880000: 0x4,
				            0x980000: 0x100,
				            0xa80000: 0x4010000,
				            0xb80000: 0x10104,
				            0xc80000: 0x10100,
				            0xd80000: 0x4000104,
				            0xe80000: 0x4010104,
				            0xf80000: 0x4000000,
				            0x1000000: 0x4010100,
				            0x1100000: 0x10004,
				            0x1200000: 0x10000,
				            0x1300000: 0x4000100,
				            0x1400000: 0x100,
				            0x1500000: 0x4010104,
				            0x1600000: 0x4000004,
				            0x1700000: 0x0,
				            0x1800000: 0x4000104,
				            0x1900000: 0x4000000,
				            0x1a00000: 0x4,
				            0x1b00000: 0x10100,
				            0x1c00000: 0x4010000,
				            0x1d00000: 0x104,
				            0x1e00000: 0x10104,
				            0x1f00000: 0x4010004,
				            0x1080000: 0x4000000,
				            0x1180000: 0x104,
				            0x1280000: 0x4010100,
				            0x1380000: 0x0,
				            0x1480000: 0x10004,
				            0x1580000: 0x4000100,
				            0x1680000: 0x100,
				            0x1780000: 0x4010004,
				            0x1880000: 0x10000,
				            0x1980000: 0x4010104,
				            0x1a80000: 0x10104,
				            0x1b80000: 0x4000004,
				            0x1c80000: 0x4000104,
				            0x1d80000: 0x4010000,
				            0x1e80000: 0x4,
				            0x1f80000: 0x10100
				        },
				        {
				            0x0: 0x80401000,
				            0x10000: 0x80001040,
				            0x20000: 0x401040,
				            0x30000: 0x80400000,
				            0x40000: 0x0,
				            0x50000: 0x401000,
				            0x60000: 0x80000040,
				            0x70000: 0x400040,
				            0x80000: 0x80000000,
				            0x90000: 0x400000,
				            0xa0000: 0x40,
				            0xb0000: 0x80001000,
				            0xc0000: 0x80400040,
				            0xd0000: 0x1040,
				            0xe0000: 0x1000,
				            0xf0000: 0x80401040,
				            0x8000: 0x80001040,
				            0x18000: 0x40,
				            0x28000: 0x80400040,
				            0x38000: 0x80001000,
				            0x48000: 0x401000,
				            0x58000: 0x80401040,
				            0x68000: 0x0,
				            0x78000: 0x80400000,
				            0x88000: 0x1000,
				            0x98000: 0x80401000,
				            0xa8000: 0x400000,
				            0xb8000: 0x1040,
				            0xc8000: 0x80000000,
				            0xd8000: 0x400040,
				            0xe8000: 0x401040,
				            0xf8000: 0x80000040,
				            0x100000: 0x400040,
				            0x110000: 0x401000,
				            0x120000: 0x80000040,
				            0x130000: 0x0,
				            0x140000: 0x1040,
				            0x150000: 0x80400040,
				            0x160000: 0x80401000,
				            0x170000: 0x80001040,
				            0x180000: 0x80401040,
				            0x190000: 0x80000000,
				            0x1a0000: 0x80400000,
				            0x1b0000: 0x401040,
				            0x1c0000: 0x80001000,
				            0x1d0000: 0x400000,
				            0x1e0000: 0x40,
				            0x1f0000: 0x1000,
				            0x108000: 0x80400000,
				            0x118000: 0x80401040,
				            0x128000: 0x0,
				            0x138000: 0x401000,
				            0x148000: 0x400040,
				            0x158000: 0x80000000,
				            0x168000: 0x80001040,
				            0x178000: 0x40,
				            0x188000: 0x80000040,
				            0x198000: 0x1000,
				            0x1a8000: 0x80001000,
				            0x1b8000: 0x80400040,
				            0x1c8000: 0x1040,
				            0x1d8000: 0x80401000,
				            0x1e8000: 0x400000,
				            0x1f8000: 0x401040
				        },
				        {
				            0x0: 0x80,
				            0x1000: 0x1040000,
				            0x2000: 0x40000,
				            0x3000: 0x20000000,
				            0x4000: 0x20040080,
				            0x5000: 0x1000080,
				            0x6000: 0x21000080,
				            0x7000: 0x40080,
				            0x8000: 0x1000000,
				            0x9000: 0x20040000,
				            0xa000: 0x20000080,
				            0xb000: 0x21040080,
				            0xc000: 0x21040000,
				            0xd000: 0x0,
				            0xe000: 0x1040080,
				            0xf000: 0x21000000,
				            0x800: 0x1040080,
				            0x1800: 0x21000080,
				            0x2800: 0x80,
				            0x3800: 0x1040000,
				            0x4800: 0x40000,
				            0x5800: 0x20040080,
				            0x6800: 0x21040000,
				            0x7800: 0x20000000,
				            0x8800: 0x20040000,
				            0x9800: 0x0,
				            0xa800: 0x21040080,
				            0xb800: 0x1000080,
				            0xc800: 0x20000080,
				            0xd800: 0x21000000,
				            0xe800: 0x1000000,
				            0xf800: 0x40080,
				            0x10000: 0x40000,
				            0x11000: 0x80,
				            0x12000: 0x20000000,
				            0x13000: 0x21000080,
				            0x14000: 0x1000080,
				            0x15000: 0x21040000,
				            0x16000: 0x20040080,
				            0x17000: 0x1000000,
				            0x18000: 0x21040080,
				            0x19000: 0x21000000,
				            0x1a000: 0x1040000,
				            0x1b000: 0x20040000,
				            0x1c000: 0x40080,
				            0x1d000: 0x20000080,
				            0x1e000: 0x0,
				            0x1f000: 0x1040080,
				            0x10800: 0x21000080,
				            0x11800: 0x1000000,
				            0x12800: 0x1040000,
				            0x13800: 0x20040080,
				            0x14800: 0x20000000,
				            0x15800: 0x1040080,
				            0x16800: 0x80,
				            0x17800: 0x21040000,
				            0x18800: 0x40080,
				            0x19800: 0x21040080,
				            0x1a800: 0x0,
				            0x1b800: 0x21000000,
				            0x1c800: 0x1000080,
				            0x1d800: 0x40000,
				            0x1e800: 0x20040000,
				            0x1f800: 0x20000080
				        },
				        {
				            0x0: 0x10000008,
				            0x100: 0x2000,
				            0x200: 0x10200000,
				            0x300: 0x10202008,
				            0x400: 0x10002000,
				            0x500: 0x200000,
				            0x600: 0x200008,
				            0x700: 0x10000000,
				            0x800: 0x0,
				            0x900: 0x10002008,
				            0xa00: 0x202000,
				            0xb00: 0x8,
				            0xc00: 0x10200008,
				            0xd00: 0x202008,
				            0xe00: 0x2008,
				            0xf00: 0x10202000,
				            0x80: 0x10200000,
				            0x180: 0x10202008,
				            0x280: 0x8,
				            0x380: 0x200000,
				            0x480: 0x202008,
				            0x580: 0x10000008,
				            0x680: 0x10002000,
				            0x780: 0x2008,
				            0x880: 0x200008,
				            0x980: 0x2000,
				            0xa80: 0x10002008,
				            0xb80: 0x10200008,
				            0xc80: 0x0,
				            0xd80: 0x10202000,
				            0xe80: 0x202000,
				            0xf80: 0x10000000,
				            0x1000: 0x10002000,
				            0x1100: 0x10200008,
				            0x1200: 0x10202008,
				            0x1300: 0x2008,
				            0x1400: 0x200000,
				            0x1500: 0x10000000,
				            0x1600: 0x10000008,
				            0x1700: 0x202000,
				            0x1800: 0x202008,
				            0x1900: 0x0,
				            0x1a00: 0x8,
				            0x1b00: 0x10200000,
				            0x1c00: 0x2000,
				            0x1d00: 0x10002008,
				            0x1e00: 0x10202000,
				            0x1f00: 0x200008,
				            0x1080: 0x8,
				            0x1180: 0x202000,
				            0x1280: 0x200000,
				            0x1380: 0x10000008,
				            0x1480: 0x10002000,
				            0x1580: 0x2008,
				            0x1680: 0x10202008,
				            0x1780: 0x10200000,
				            0x1880: 0x10202000,
				            0x1980: 0x10200008,
				            0x1a80: 0x2000,
				            0x1b80: 0x202008,
				            0x1c80: 0x200008,
				            0x1d80: 0x0,
				            0x1e80: 0x10000000,
				            0x1f80: 0x10002008
				        },
				        {
				            0x0: 0x100000,
				            0x10: 0x2000401,
				            0x20: 0x400,
				            0x30: 0x100401,
				            0x40: 0x2100401,
				            0x50: 0x0,
				            0x60: 0x1,
				            0x70: 0x2100001,
				            0x80: 0x2000400,
				            0x90: 0x100001,
				            0xa0: 0x2000001,
				            0xb0: 0x2100400,
				            0xc0: 0x2100000,
				            0xd0: 0x401,
				            0xe0: 0x100400,
				            0xf0: 0x2000000,
				            0x8: 0x2100001,
				            0x18: 0x0,
				            0x28: 0x2000401,
				            0x38: 0x2100400,
				            0x48: 0x100000,
				            0x58: 0x2000001,
				            0x68: 0x2000000,
				            0x78: 0x401,
				            0x88: 0x100401,
				            0x98: 0x2000400,
				            0xa8: 0x2100000,
				            0xb8: 0x100001,
				            0xc8: 0x400,
				            0xd8: 0x2100401,
				            0xe8: 0x1,
				            0xf8: 0x100400,
				            0x100: 0x2000000,
				            0x110: 0x100000,
				            0x120: 0x2000401,
				            0x130: 0x2100001,
				            0x140: 0x100001,
				            0x150: 0x2000400,
				            0x160: 0x2100400,
				            0x170: 0x100401,
				            0x180: 0x401,
				            0x190: 0x2100401,
				            0x1a0: 0x100400,
				            0x1b0: 0x1,
				            0x1c0: 0x0,
				            0x1d0: 0x2100000,
				            0x1e0: 0x2000001,
				            0x1f0: 0x400,
				            0x108: 0x100400,
				            0x118: 0x2000401,
				            0x128: 0x2100001,
				            0x138: 0x1,
				            0x148: 0x2000000,
				            0x158: 0x100000,
				            0x168: 0x401,
				            0x178: 0x2100400,
				            0x188: 0x2000001,
				            0x198: 0x2100000,
				            0x1a8: 0x0,
				            0x1b8: 0x2100401,
				            0x1c8: 0x100401,
				            0x1d8: 0x400,
				            0x1e8: 0x2000400,
				            0x1f8: 0x100001
				        },
				        {
				            0x0: 0x8000820,
				            0x1: 0x20000,
				            0x2: 0x8000000,
				            0x3: 0x20,
				            0x4: 0x20020,
				            0x5: 0x8020820,
				            0x6: 0x8020800,
				            0x7: 0x800,
				            0x8: 0x8020000,
				            0x9: 0x8000800,
				            0xa: 0x20800,
				            0xb: 0x8020020,
				            0xc: 0x820,
				            0xd: 0x0,
				            0xe: 0x8000020,
				            0xf: 0x20820,
				            0x80000000: 0x800,
				            0x80000001: 0x8020820,
				            0x80000002: 0x8000820,
				            0x80000003: 0x8000000,
				            0x80000004: 0x8020000,
				            0x80000005: 0x20800,
				            0x80000006: 0x20820,
				            0x80000007: 0x20,
				            0x80000008: 0x8000020,
				            0x80000009: 0x820,
				            0x8000000a: 0x20020,
				            0x8000000b: 0x8020800,
				            0x8000000c: 0x0,
				            0x8000000d: 0x8020020,
				            0x8000000e: 0x8000800,
				            0x8000000f: 0x20000,
				            0x10: 0x20820,
				            0x11: 0x8020800,
				            0x12: 0x20,
				            0x13: 0x800,
				            0x14: 0x8000800,
				            0x15: 0x8000020,
				            0x16: 0x8020020,
				            0x17: 0x20000,
				            0x18: 0x0,
				            0x19: 0x20020,
				            0x1a: 0x8020000,
				            0x1b: 0x8000820,
				            0x1c: 0x8020820,
				            0x1d: 0x20800,
				            0x1e: 0x820,
				            0x1f: 0x8000000,
				            0x80000010: 0x20000,
				            0x80000011: 0x800,
				            0x80000012: 0x8020020,
				            0x80000013: 0x20820,
				            0x80000014: 0x20,
				            0x80000015: 0x8020000,
				            0x80000016: 0x8000000,
				            0x80000017: 0x8000820,
				            0x80000018: 0x8020820,
				            0x80000019: 0x8000020,
				            0x8000001a: 0x8000800,
				            0x8000001b: 0x0,
				            0x8000001c: 0x20800,
				            0x8000001d: 0x820,
				            0x8000001e: 0x20020,
				            0x8000001f: 0x8020800
				        }
				    ];

				    // Masks that select the SBOX input
				    var SBOX_MASK = [
				        0xf8000001, 0x1f800000, 0x01f80000, 0x001f8000,
				        0x0001f800, 0x00001f80, 0x000001f8, 0x8000001f
				    ];

				    /**
				     * DES block cipher algorithm.
				     */
				    var DES = C_algo.DES = BlockCipher.extend({
				        _doReset: function () {
				            // Shortcuts
				            var key = this._key;
				            var keyWords = key.words;

				            // Select 56 bits according to PC1
				            var keyBits = [];
				            for (var i = 0; i < 56; i++) {
				                var keyBitPos = PC1[i] - 1;
				                keyBits[i] = (keyWords[keyBitPos >>> 5] >>> (31 - keyBitPos % 32)) & 1;
				            }

				            // Assemble 16 subkeys
				            var subKeys = this._subKeys = [];
				            for (var nSubKey = 0; nSubKey < 16; nSubKey++) {
				                // Create subkey
				                var subKey = subKeys[nSubKey] = [];

				                // Shortcut
				                var bitShift = BIT_SHIFTS[nSubKey];

				                // Select 48 bits according to PC2
				                for (var i = 0; i < 24; i++) {
				                    // Select from the left 28 key bits
				                    subKey[(i / 6) | 0] |= keyBits[((PC2[i] - 1) + bitShift) % 28] << (31 - i % 6);

				                    // Select from the right 28 key bits
				                    subKey[4 + ((i / 6) | 0)] |= keyBits[28 + (((PC2[i + 24] - 1) + bitShift) % 28)] << (31 - i % 6);
				                }

				                // Since each subkey is applied to an expanded 32-bit input,
				                // the subkey can be broken into 8 values scaled to 32-bits,
				                // which allows the key to be used without expansion
				                subKey[0] = (subKey[0] << 1) | (subKey[0] >>> 31);
				                for (var i = 1; i < 7; i++) {
				                    subKey[i] = subKey[i] >>> ((i - 1) * 4 + 3);
				                }
				                subKey[7] = (subKey[7] << 5) | (subKey[7] >>> 27);
				            }

				            // Compute inverse subkeys
				            var invSubKeys = this._invSubKeys = [];
				            for (var i = 0; i < 16; i++) {
				                invSubKeys[i] = subKeys[15 - i];
				            }
				        },

				        encryptBlock: function (M, offset) {
				            this._doCryptBlock(M, offset, this._subKeys);
				        },

				        decryptBlock: function (M, offset) {
				            this._doCryptBlock(M, offset, this._invSubKeys);
				        },

				        _doCryptBlock: function (M, offset, subKeys) {
				            // Get input
				            this._lBlock = M[offset];
				            this._rBlock = M[offset + 1];

				            // Initial permutation
				            exchangeLR.call(this, 4,  0x0f0f0f0f);
				            exchangeLR.call(this, 16, 0x0000ffff);
				            exchangeRL.call(this, 2,  0x33333333);
				            exchangeRL.call(this, 8,  0x00ff00ff);
				            exchangeLR.call(this, 1,  0x55555555);

				            // Rounds
				            for (var round = 0; round < 16; round++) {
				                // Shortcuts
				                var subKey = subKeys[round];
				                var lBlock = this._lBlock;
				                var rBlock = this._rBlock;

				                // Feistel function
				                var f = 0;
				                for (var i = 0; i < 8; i++) {
				                    f |= SBOX_P[i][((rBlock ^ subKey[i]) & SBOX_MASK[i]) >>> 0];
				                }
				                this._lBlock = rBlock;
				                this._rBlock = lBlock ^ f;
				            }

				            // Undo swap from last round
				            var t = this._lBlock;
				            this._lBlock = this._rBlock;
				            this._rBlock = t;

				            // Final permutation
				            exchangeLR.call(this, 1,  0x55555555);
				            exchangeRL.call(this, 8,  0x00ff00ff);
				            exchangeRL.call(this, 2,  0x33333333);
				            exchangeLR.call(this, 16, 0x0000ffff);
				            exchangeLR.call(this, 4,  0x0f0f0f0f);

				            // Set output
				            M[offset] = this._lBlock;
				            M[offset + 1] = this._rBlock;
				        },

				        keySize: 64/32,

				        ivSize: 64/32,

				        blockSize: 64/32
				    });

				    // Swap bits across the left and right words
				    function exchangeLR(offset, mask) {
				        var t = ((this._lBlock >>> offset) ^ this._rBlock) & mask;
				        this._rBlock ^= t;
				        this._lBlock ^= t << offset;
				    }

				    function exchangeRL(offset, mask) {
				        var t = ((this._rBlock >>> offset) ^ this._lBlock) & mask;
				        this._lBlock ^= t;
				        this._rBlock ^= t << offset;
				    }

				    /**
				     * Shortcut functions to the cipher's object interface.
				     *
				     * @example
				     *
				     *     var ciphertext = CryptoJS.DES.encrypt(message, key, cfg);
				     *     var plaintext  = CryptoJS.DES.decrypt(ciphertext, key, cfg);
				     */
				    C.DES = BlockCipher._createHelper(DES);

				    /**
				     * Triple-DES block cipher algorithm.
				     */
				    var TripleDES = C_algo.TripleDES = BlockCipher.extend({
				        _doReset: function () {
				            // Shortcuts
				            var key = this._key;
				            var keyWords = key.words;

				            // Create DES instances
				            this._des1 = DES.createEncryptor(WordArray.create(keyWords.slice(0, 2)));
				            this._des2 = DES.createEncryptor(WordArray.create(keyWords.slice(2, 4)));
				            this._des3 = DES.createEncryptor(WordArray.create(keyWords.slice(4, 6)));
				        },

				        encryptBlock: function (M, offset) {
				            this._des1.encryptBlock(M, offset);
				            this._des2.decryptBlock(M, offset);
				            this._des3.encryptBlock(M, offset);
				        },

				        decryptBlock: function (M, offset) {
				            this._des3.decryptBlock(M, offset);
				            this._des2.encryptBlock(M, offset);
				            this._des1.decryptBlock(M, offset);
				        },

				        keySize: 192/32,

				        ivSize: 64/32,

				        blockSize: 64/32
				    });

				    /**
				     * Shortcut functions to the cipher's object interface.
				     *
				     * @example
				     *
				     *     var ciphertext = CryptoJS.TripleDES.encrypt(message, key, cfg);
				     *     var plaintext  = CryptoJS.TripleDES.decrypt(ciphertext, key, cfg);
				     */
				    C.TripleDES = BlockCipher._createHelper(TripleDES);
				}());


				return CryptoJS.TripleDES;

			}));
		} (tripledes));
		return tripledes.exports;
	}

	var rc4 = {exports: {}};

	var hasRequiredRc4;

	function requireRc4 () {
		if (hasRequiredRc4) return rc4.exports;
		hasRequiredRc4 = 1;
		(function (module, exports) {
	(function (root, factory, undef) {
				{
					// CommonJS
					module.exports = factory(requireCore(), requireEncBase64(), requireMd5(), requireEvpkdf(), requireCipherCore());
				}
			}(commonjsGlobal, function (CryptoJS) {

				(function () {
				    // Shortcuts
				    var C = CryptoJS;
				    var C_lib = C.lib;
				    var StreamCipher = C_lib.StreamCipher;
				    var C_algo = C.algo;

				    /**
				     * RC4 stream cipher algorithm.
				     */
				    var RC4 = C_algo.RC4 = StreamCipher.extend({
				        _doReset: function () {
				            // Shortcuts
				            var key = this._key;
				            var keyWords = key.words;
				            var keySigBytes = key.sigBytes;

				            // Init sbox
				            var S = this._S = [];
				            for (var i = 0; i < 256; i++) {
				                S[i] = i;
				            }

				            // Key setup
				            for (var i = 0, j = 0; i < 256; i++) {
				                var keyByteIndex = i % keySigBytes;
				                var keyByte = (keyWords[keyByteIndex >>> 2] >>> (24 - (keyByteIndex % 4) * 8)) & 0xff;

				                j = (j + S[i] + keyByte) % 256;

				                // Swap
				                var t = S[i];
				                S[i] = S[j];
				                S[j] = t;
				            }

				            // Counters
				            this._i = this._j = 0;
				        },

				        _doProcessBlock: function (M, offset) {
				            M[offset] ^= generateKeystreamWord.call(this);
				        },

				        keySize: 256/32,

				        ivSize: 0
				    });

				    function generateKeystreamWord() {
				        // Shortcuts
				        var S = this._S;
				        var i = this._i;
				        var j = this._j;

				        // Generate keystream word
				        var keystreamWord = 0;
				        for (var n = 0; n < 4; n++) {
				            i = (i + 1) % 256;
				            j = (j + S[i]) % 256;

				            // Swap
				            var t = S[i];
				            S[i] = S[j];
				            S[j] = t;

				            keystreamWord |= S[(S[i] + S[j]) % 256] << (24 - n * 8);
				        }

				        // Update counters
				        this._i = i;
				        this._j = j;

				        return keystreamWord;
				    }

				    /**
				     * Shortcut functions to the cipher's object interface.
				     *
				     * @example
				     *
				     *     var ciphertext = CryptoJS.RC4.encrypt(message, key, cfg);
				     *     var plaintext  = CryptoJS.RC4.decrypt(ciphertext, key, cfg);
				     */
				    C.RC4 = StreamCipher._createHelper(RC4);

				    /**
				     * Modified RC4 stream cipher algorithm.
				     */
				    var RC4Drop = C_algo.RC4Drop = RC4.extend({
				        /**
				         * Configuration options.
				         *
				         * @property {number} drop The number of keystream words to drop. Default 192
				         */
				        cfg: RC4.cfg.extend({
				            drop: 192
				        }),

				        _doReset: function () {
				            RC4._doReset.call(this);

				            // Drop
				            for (var i = this.cfg.drop; i > 0; i--) {
				                generateKeystreamWord.call(this);
				            }
				        }
				    });

				    /**
				     * Shortcut functions to the cipher's object interface.
				     *
				     * @example
				     *
				     *     var ciphertext = CryptoJS.RC4Drop.encrypt(message, key, cfg);
				     *     var plaintext  = CryptoJS.RC4Drop.decrypt(ciphertext, key, cfg);
				     */
				    C.RC4Drop = StreamCipher._createHelper(RC4Drop);
				}());


				return CryptoJS.RC4;

			}));
		} (rc4));
		return rc4.exports;
	}

	var rabbit = {exports: {}};

	var hasRequiredRabbit;

	function requireRabbit () {
		if (hasRequiredRabbit) return rabbit.exports;
		hasRequiredRabbit = 1;
		(function (module, exports) {
	(function (root, factory, undef) {
				{
					// CommonJS
					module.exports = factory(requireCore(), requireEncBase64(), requireMd5(), requireEvpkdf(), requireCipherCore());
				}
			}(commonjsGlobal, function (CryptoJS) {

				(function () {
				    // Shortcuts
				    var C = CryptoJS;
				    var C_lib = C.lib;
				    var StreamCipher = C_lib.StreamCipher;
				    var C_algo = C.algo;

				    // Reusable objects
				    var S  = [];
				    var C_ = [];
				    var G  = [];

				    /**
				     * Rabbit stream cipher algorithm
				     */
				    var Rabbit = C_algo.Rabbit = StreamCipher.extend({
				        _doReset: function () {
				            // Shortcuts
				            var K = this._key.words;
				            var iv = this.cfg.iv;

				            // Swap endian
				            for (var i = 0; i < 4; i++) {
				                K[i] = (((K[i] << 8)  | (K[i] >>> 24)) & 0x00ff00ff) |
				                       (((K[i] << 24) | (K[i] >>> 8))  & 0xff00ff00);
				            }

				            // Generate initial state values
				            var X = this._X = [
				                K[0], (K[3] << 16) | (K[2] >>> 16),
				                K[1], (K[0] << 16) | (K[3] >>> 16),
				                K[2], (K[1] << 16) | (K[0] >>> 16),
				                K[3], (K[2] << 16) | (K[1] >>> 16)
				            ];

				            // Generate initial counter values
				            var C = this._C = [
				                (K[2] << 16) | (K[2] >>> 16), (K[0] & 0xffff0000) | (K[1] & 0x0000ffff),
				                (K[3] << 16) | (K[3] >>> 16), (K[1] & 0xffff0000) | (K[2] & 0x0000ffff),
				                (K[0] << 16) | (K[0] >>> 16), (K[2] & 0xffff0000) | (K[3] & 0x0000ffff),
				                (K[1] << 16) | (K[1] >>> 16), (K[3] & 0xffff0000) | (K[0] & 0x0000ffff)
				            ];

				            // Carry bit
				            this._b = 0;

				            // Iterate the system four times
				            for (var i = 0; i < 4; i++) {
				                nextState.call(this);
				            }

				            // Modify the counters
				            for (var i = 0; i < 8; i++) {
				                C[i] ^= X[(i + 4) & 7];
				            }

				            // IV setup
				            if (iv) {
				                // Shortcuts
				                var IV = iv.words;
				                var IV_0 = IV[0];
				                var IV_1 = IV[1];

				                // Generate four subvectors
				                var i0 = (((IV_0 << 8) | (IV_0 >>> 24)) & 0x00ff00ff) | (((IV_0 << 24) | (IV_0 >>> 8)) & 0xff00ff00);
				                var i2 = (((IV_1 << 8) | (IV_1 >>> 24)) & 0x00ff00ff) | (((IV_1 << 24) | (IV_1 >>> 8)) & 0xff00ff00);
				                var i1 = (i0 >>> 16) | (i2 & 0xffff0000);
				                var i3 = (i2 << 16)  | (i0 & 0x0000ffff);

				                // Modify counter values
				                C[0] ^= i0;
				                C[1] ^= i1;
				                C[2] ^= i2;
				                C[3] ^= i3;
				                C[4] ^= i0;
				                C[5] ^= i1;
				                C[6] ^= i2;
				                C[7] ^= i3;

				                // Iterate the system four times
				                for (var i = 0; i < 4; i++) {
				                    nextState.call(this);
				                }
				            }
				        },

				        _doProcessBlock: function (M, offset) {
				            // Shortcut
				            var X = this._X;

				            // Iterate the system
				            nextState.call(this);

				            // Generate four keystream words
				            S[0] = X[0] ^ (X[5] >>> 16) ^ (X[3] << 16);
				            S[1] = X[2] ^ (X[7] >>> 16) ^ (X[5] << 16);
				            S[2] = X[4] ^ (X[1] >>> 16) ^ (X[7] << 16);
				            S[3] = X[6] ^ (X[3] >>> 16) ^ (X[1] << 16);

				            for (var i = 0; i < 4; i++) {
				                // Swap endian
				                S[i] = (((S[i] << 8)  | (S[i] >>> 24)) & 0x00ff00ff) |
				                       (((S[i] << 24) | (S[i] >>> 8))  & 0xff00ff00);

				                // Encrypt
				                M[offset + i] ^= S[i];
				            }
				        },

				        blockSize: 128/32,

				        ivSize: 64/32
				    });

				    function nextState() {
				        // Shortcuts
				        var X = this._X;
				        var C = this._C;

				        // Save old counter values
				        for (var i = 0; i < 8; i++) {
				            C_[i] = C[i];
				        }

				        // Calculate new counter values
				        C[0] = (C[0] + 0x4d34d34d + this._b) | 0;
				        C[1] = (C[1] + 0xd34d34d3 + ((C[0] >>> 0) < (C_[0] >>> 0) ? 1 : 0)) | 0;
				        C[2] = (C[2] + 0x34d34d34 + ((C[1] >>> 0) < (C_[1] >>> 0) ? 1 : 0)) | 0;
				        C[3] = (C[3] + 0x4d34d34d + ((C[2] >>> 0) < (C_[2] >>> 0) ? 1 : 0)) | 0;
				        C[4] = (C[4] + 0xd34d34d3 + ((C[3] >>> 0) < (C_[3] >>> 0) ? 1 : 0)) | 0;
				        C[5] = (C[5] + 0x34d34d34 + ((C[4] >>> 0) < (C_[4] >>> 0) ? 1 : 0)) | 0;
				        C[6] = (C[6] + 0x4d34d34d + ((C[5] >>> 0) < (C_[5] >>> 0) ? 1 : 0)) | 0;
				        C[7] = (C[7] + 0xd34d34d3 + ((C[6] >>> 0) < (C_[6] >>> 0) ? 1 : 0)) | 0;
				        this._b = (C[7] >>> 0) < (C_[7] >>> 0) ? 1 : 0;

				        // Calculate the g-values
				        for (var i = 0; i < 8; i++) {
				            var gx = X[i] + C[i];

				            // Construct high and low argument for squaring
				            var ga = gx & 0xffff;
				            var gb = gx >>> 16;

				            // Calculate high and low result of squaring
				            var gh = ((((ga * ga) >>> 17) + ga * gb) >>> 15) + gb * gb;
				            var gl = (((gx & 0xffff0000) * gx) | 0) + (((gx & 0x0000ffff) * gx) | 0);

				            // High XOR low
				            G[i] = gh ^ gl;
				        }

				        // Calculate new state values
				        X[0] = (G[0] + ((G[7] << 16) | (G[7] >>> 16)) + ((G[6] << 16) | (G[6] >>> 16))) | 0;
				        X[1] = (G[1] + ((G[0] << 8)  | (G[0] >>> 24)) + G[7]) | 0;
				        X[2] = (G[2] + ((G[1] << 16) | (G[1] >>> 16)) + ((G[0] << 16) | (G[0] >>> 16))) | 0;
				        X[3] = (G[3] + ((G[2] << 8)  | (G[2] >>> 24)) + G[1]) | 0;
				        X[4] = (G[4] + ((G[3] << 16) | (G[3] >>> 16)) + ((G[2] << 16) | (G[2] >>> 16))) | 0;
				        X[5] = (G[5] + ((G[4] << 8)  | (G[4] >>> 24)) + G[3]) | 0;
				        X[6] = (G[6] + ((G[5] << 16) | (G[5] >>> 16)) + ((G[4] << 16) | (G[4] >>> 16))) | 0;
				        X[7] = (G[7] + ((G[6] << 8)  | (G[6] >>> 24)) + G[5]) | 0;
				    }

				    /**
				     * Shortcut functions to the cipher's object interface.
				     *
				     * @example
				     *
				     *     var ciphertext = CryptoJS.Rabbit.encrypt(message, key, cfg);
				     *     var plaintext  = CryptoJS.Rabbit.decrypt(ciphertext, key, cfg);
				     */
				    C.Rabbit = StreamCipher._createHelper(Rabbit);
				}());


				return CryptoJS.Rabbit;

			}));
		} (rabbit));
		return rabbit.exports;
	}

	var rabbitLegacy = {exports: {}};

	var hasRequiredRabbitLegacy;

	function requireRabbitLegacy () {
		if (hasRequiredRabbitLegacy) return rabbitLegacy.exports;
		hasRequiredRabbitLegacy = 1;
		(function (module, exports) {
	(function (root, factory, undef) {
				{
					// CommonJS
					module.exports = factory(requireCore(), requireEncBase64(), requireMd5(), requireEvpkdf(), requireCipherCore());
				}
			}(commonjsGlobal, function (CryptoJS) {

				(function () {
				    // Shortcuts
				    var C = CryptoJS;
				    var C_lib = C.lib;
				    var StreamCipher = C_lib.StreamCipher;
				    var C_algo = C.algo;

				    // Reusable objects
				    var S  = [];
				    var C_ = [];
				    var G  = [];

				    /**
				     * Rabbit stream cipher algorithm.
				     *
				     * This is a legacy version that neglected to convert the key to little-endian.
				     * This error doesn't affect the cipher's security,
				     * but it does affect its compatibility with other implementations.
				     */
				    var RabbitLegacy = C_algo.RabbitLegacy = StreamCipher.extend({
				        _doReset: function () {
				            // Shortcuts
				            var K = this._key.words;
				            var iv = this.cfg.iv;

				            // Generate initial state values
				            var X = this._X = [
				                K[0], (K[3] << 16) | (K[2] >>> 16),
				                K[1], (K[0] << 16) | (K[3] >>> 16),
				                K[2], (K[1] << 16) | (K[0] >>> 16),
				                K[3], (K[2] << 16) | (K[1] >>> 16)
				            ];

				            // Generate initial counter values
				            var C = this._C = [
				                (K[2] << 16) | (K[2] >>> 16), (K[0] & 0xffff0000) | (K[1] & 0x0000ffff),
				                (K[3] << 16) | (K[3] >>> 16), (K[1] & 0xffff0000) | (K[2] & 0x0000ffff),
				                (K[0] << 16) | (K[0] >>> 16), (K[2] & 0xffff0000) | (K[3] & 0x0000ffff),
				                (K[1] << 16) | (K[1] >>> 16), (K[3] & 0xffff0000) | (K[0] & 0x0000ffff)
				            ];

				            // Carry bit
				            this._b = 0;

				            // Iterate the system four times
				            for (var i = 0; i < 4; i++) {
				                nextState.call(this);
				            }

				            // Modify the counters
				            for (var i = 0; i < 8; i++) {
				                C[i] ^= X[(i + 4) & 7];
				            }

				            // IV setup
				            if (iv) {
				                // Shortcuts
				                var IV = iv.words;
				                var IV_0 = IV[0];
				                var IV_1 = IV[1];

				                // Generate four subvectors
				                var i0 = (((IV_0 << 8) | (IV_0 >>> 24)) & 0x00ff00ff) | (((IV_0 << 24) | (IV_0 >>> 8)) & 0xff00ff00);
				                var i2 = (((IV_1 << 8) | (IV_1 >>> 24)) & 0x00ff00ff) | (((IV_1 << 24) | (IV_1 >>> 8)) & 0xff00ff00);
				                var i1 = (i0 >>> 16) | (i2 & 0xffff0000);
				                var i3 = (i2 << 16)  | (i0 & 0x0000ffff);

				                // Modify counter values
				                C[0] ^= i0;
				                C[1] ^= i1;
				                C[2] ^= i2;
				                C[3] ^= i3;
				                C[4] ^= i0;
				                C[5] ^= i1;
				                C[6] ^= i2;
				                C[7] ^= i3;

				                // Iterate the system four times
				                for (var i = 0; i < 4; i++) {
				                    nextState.call(this);
				                }
				            }
				        },

				        _doProcessBlock: function (M, offset) {
				            // Shortcut
				            var X = this._X;

				            // Iterate the system
				            nextState.call(this);

				            // Generate four keystream words
				            S[0] = X[0] ^ (X[5] >>> 16) ^ (X[3] << 16);
				            S[1] = X[2] ^ (X[7] >>> 16) ^ (X[5] << 16);
				            S[2] = X[4] ^ (X[1] >>> 16) ^ (X[7] << 16);
				            S[3] = X[6] ^ (X[3] >>> 16) ^ (X[1] << 16);

				            for (var i = 0; i < 4; i++) {
				                // Swap endian
				                S[i] = (((S[i] << 8)  | (S[i] >>> 24)) & 0x00ff00ff) |
				                       (((S[i] << 24) | (S[i] >>> 8))  & 0xff00ff00);

				                // Encrypt
				                M[offset + i] ^= S[i];
				            }
				        },

				        blockSize: 128/32,

				        ivSize: 64/32
				    });

				    function nextState() {
				        // Shortcuts
				        var X = this._X;
				        var C = this._C;

				        // Save old counter values
				        for (var i = 0; i < 8; i++) {
				            C_[i] = C[i];
				        }

				        // Calculate new counter values
				        C[0] = (C[0] + 0x4d34d34d + this._b) | 0;
				        C[1] = (C[1] + 0xd34d34d3 + ((C[0] >>> 0) < (C_[0] >>> 0) ? 1 : 0)) | 0;
				        C[2] = (C[2] + 0x34d34d34 + ((C[1] >>> 0) < (C_[1] >>> 0) ? 1 : 0)) | 0;
				        C[3] = (C[3] + 0x4d34d34d + ((C[2] >>> 0) < (C_[2] >>> 0) ? 1 : 0)) | 0;
				        C[4] = (C[4] + 0xd34d34d3 + ((C[3] >>> 0) < (C_[3] >>> 0) ? 1 : 0)) | 0;
				        C[5] = (C[5] + 0x34d34d34 + ((C[4] >>> 0) < (C_[4] >>> 0) ? 1 : 0)) | 0;
				        C[6] = (C[6] + 0x4d34d34d + ((C[5] >>> 0) < (C_[5] >>> 0) ? 1 : 0)) | 0;
				        C[7] = (C[7] + 0xd34d34d3 + ((C[6] >>> 0) < (C_[6] >>> 0) ? 1 : 0)) | 0;
				        this._b = (C[7] >>> 0) < (C_[7] >>> 0) ? 1 : 0;

				        // Calculate the g-values
				        for (var i = 0; i < 8; i++) {
				            var gx = X[i] + C[i];

				            // Construct high and low argument for squaring
				            var ga = gx & 0xffff;
				            var gb = gx >>> 16;

				            // Calculate high and low result of squaring
				            var gh = ((((ga * ga) >>> 17) + ga * gb) >>> 15) + gb * gb;
				            var gl = (((gx & 0xffff0000) * gx) | 0) + (((gx & 0x0000ffff) * gx) | 0);

				            // High XOR low
				            G[i] = gh ^ gl;
				        }

				        // Calculate new state values
				        X[0] = (G[0] + ((G[7] << 16) | (G[7] >>> 16)) + ((G[6] << 16) | (G[6] >>> 16))) | 0;
				        X[1] = (G[1] + ((G[0] << 8)  | (G[0] >>> 24)) + G[7]) | 0;
				        X[2] = (G[2] + ((G[1] << 16) | (G[1] >>> 16)) + ((G[0] << 16) | (G[0] >>> 16))) | 0;
				        X[3] = (G[3] + ((G[2] << 8)  | (G[2] >>> 24)) + G[1]) | 0;
				        X[4] = (G[4] + ((G[3] << 16) | (G[3] >>> 16)) + ((G[2] << 16) | (G[2] >>> 16))) | 0;
				        X[5] = (G[5] + ((G[4] << 8)  | (G[4] >>> 24)) + G[3]) | 0;
				        X[6] = (G[6] + ((G[5] << 16) | (G[5] >>> 16)) + ((G[4] << 16) | (G[4] >>> 16))) | 0;
				        X[7] = (G[7] + ((G[6] << 8)  | (G[6] >>> 24)) + G[5]) | 0;
				    }

				    /**
				     * Shortcut functions to the cipher's object interface.
				     *
				     * @example
				     *
				     *     var ciphertext = CryptoJS.RabbitLegacy.encrypt(message, key, cfg);
				     *     var plaintext  = CryptoJS.RabbitLegacy.decrypt(ciphertext, key, cfg);
				     */
				    C.RabbitLegacy = StreamCipher._createHelper(RabbitLegacy);
				}());


				return CryptoJS.RabbitLegacy;

			}));
		} (rabbitLegacy));
		return rabbitLegacy.exports;
	}

	(function (module, exports) {
	(function (root, factory, undef) {
			{
				// CommonJS
				module.exports = factory(requireCore(), requireX64Core(), requireLibTypedarrays(), requireEncUtf16(), requireEncBase64(), requireMd5(), requireSha1(), requireSha256(), requireSha224(), requireSha512(), requireSha384(), requireSha3(), requireRipemd160(), requireHmac(), requirePbkdf2(), requireEvpkdf(), requireCipherCore(), requireModeCfb(), requireModeCtr(), requireModeCtrGladman(), requireModeOfb(), requireModeEcb(), requirePadAnsix923(), requirePadIso10126(), requirePadIso97971(), requirePadZeropadding(), requirePadNopadding(), requireFormatHex(), requireAes(), requireTripledes(), requireRc4(), requireRabbit(), requireRabbitLegacy());
			}
		}(commonjsGlobal, function (CryptoJS) {

			return CryptoJS;

		}));
	} (cryptoJs));

	var cryptoJsExports = cryptoJs.exports;

	/**
	 * Rocket.Chat RealTime API
	 */
	Object.defineProperty(RealTimeAPI$2, "__esModule", { value: true });
	var webSocket_1 = require$$0;
	var operators_1 = require$$1;
	var uuid_1 = uuid_1$1;
	var crypto_js_1 = cryptoJsExports;
	var RealTimeAPI$1 = /** @class */ (function () {
	    function RealTimeAPI(param) {
	        this.webSocket = webSocket_1.webSocket(param);
	    }
	    /**
	     * Returns the Observable to the RealTime API Socket
	     */
	    RealTimeAPI.prototype.getObservable = function () {
	        return this.webSocket;
	    };
	    /**
	     * Disconnect the WebSocket Connection between client and RealTime API
	     */
	    RealTimeAPI.prototype.disconnect = function () {
	        return this.webSocket.unsubscribe();
	    };
	    /**
	     * onMessage
	     */
	    RealTimeAPI.prototype.onMessage = function (messageHandler) {
	        this.subscribe(messageHandler, undefined, undefined);
	    };
	    /**
	     * onError
	     */
	    RealTimeAPI.prototype.onError = function (errorHandler) {
	        this.subscribe(undefined, errorHandler, undefined);
	    };
	    /**
	     * onCompletion
	     */
	    RealTimeAPI.prototype.onCompletion = function (completionHandler) {
	        this.subscribe(undefined, undefined, completionHandler);
	    };
	    /**
	     * Subscribe to the WebSocket of the RealTime API
	     */
	    RealTimeAPI.prototype.subscribe = function (messageHandler, errorHandler, completionHandler) {
	        this.getObservable().subscribe(messageHandler, errorHandler, completionHandler);
	    };
	    /**
	     * sendMessage to Rocket.Chat Server
	     */
	    RealTimeAPI.prototype.sendMessage = function (messageObject) {
	        this.webSocket.next(messageObject);
	    };
	    /**
	     * getObservableFilteredByMessageType
	     */
	    RealTimeAPI.prototype.getObservableFilteredByMessageType = function (messageType) {
	        return this.getObservable().pipe(operators_1.filter(function (message) { return message.msg === messageType; }));
	    };
	    /**
	     * getObservableFilteredByID
	     */
	    RealTimeAPI.prototype.getObservableFilteredByID = function (id) {
	        return this.getObservable().pipe(operators_1.filter(function (message) { return message.id === id; }));
	    };
	    /**
	     * connectToServer
	     */
	    RealTimeAPI.prototype.connectToServer = function () {
	        this.sendMessage({
	            msg: "connect",
	            version: "1",
	            support: ["1", "pre2", "pre1"]
	        });
	        return this.getObservableFilteredByMessageType("connected");
	    };
	    /**
	     * Returns an Observable to subscribe to keepAlive, Ping and Pong to the Rocket.Chat Server to Keep the Connection Alive.
	     */
	    RealTimeAPI.prototype.keepAlive = function () {
	        var _this = this;
	        return this.getObservableFilteredByMessageType("ping").pipe(operators_1.tap(function () { return _this.sendMessage({ msg: "pong" }); }));
	    };
	    /**
	     * Login with Username and Password
	     */
	    RealTimeAPI.prototype.login = function (username, password) {
	        var _a;
	        var id = uuid_1.v4();
	        var usernameType = username.indexOf("@") !== -1 ? "email" : "username";
	        this.sendMessage({
	            msg: "method",
	            method: "login",
	            id: id,
	            params: [
	                {
	                    user: (_a = {}, _a[usernameType] = username, _a),
	                    password: {
	                        digest: crypto_js_1.SHA256(password).toString(),
	                        algorithm: "sha-256"
	                    }
	                }
	            ]
	        });
	        return this.getLoginObservable(id);
	    };
	    /**
	     * Login with Authentication Token
	     */
	    RealTimeAPI.prototype.loginWithAuthToken = function (authToken) {
	        var id = uuid_1.v4();
	        this.sendMessage({
	            msg: "method",
	            method: "login",
	            id: id,
	            params: [{ resume: authToken }]
	        });
	        return this.getLoginObservable(id);
	    };
	    /**
	     * Login with OAuth, with Client Token and Client Secret
	     */
	    RealTimeAPI.prototype.loginWithOAuth = function (credToken, credSecret) {
	        var id = uuid_1.v4();
	        this.sendMessage({
	            msg: "method",
	            method: "login",
	            id: id,
	            params: [
	                {
	                    oauth: {
	                        credentialToken: credToken,
	                        credentialSecret: credSecret
	                    }
	                }
	            ]
	        });
	        return this.getLoginObservable(id);
	    };
	    /**
	     * getLoginObservable
	     */
	    RealTimeAPI.prototype.getLoginObservable = function (id) {
	        var resultObservable = this.getObservableFilteredByID(id);
	        var resultId;
	        var addedObservable = this.getObservable().pipe(operators_1.buffer(resultObservable.pipe(operators_1.map(function (_a) {
	            var msg = _a.msg, error = _a.error, result = _a.result;
							if (msg === "result" && !error)
	                return (resultId = result.id); // Setting resultId to get Result from the buffer
	        }))), operators_1.flatMap(function (x) { return x; }), // Flattening the Buffered Messages
	        operators_1.filter(function (_a) {
	            var msgId = _a.id;
	            return resultId !== undefined && msgId === resultId;
	        }), //Filtering the "added" result message.
	        operators_1.merge(resultObservable) //Merging "result" and "added" messages.
	        );
	        return addedObservable;
	    };
	    /**
	     * Get Observalble to the Result of Method Call from Rocket.Chat Realtime API
	     */
	    RealTimeAPI.prototype.callMethod = function (method) {
	        var params = [];
	        for (var _i = 1; _i < arguments.length; _i++) {
	            params[_i - 1] = arguments[_i];
	        }
	        var id = uuid_1.v4();
	        this.sendMessage({
	            msg: "method",
	            method: method,
	            id: id,
	            params: params
	        });
	        return this.getObservableFilteredByID(id);
	    };
	    /**
	     * getSubscription
	     */
	    RealTimeAPI.prototype.getSubscription = function (streamName, streamParam, addEvent) {
	        var id = uuid_1.v4();
	        var subscription = this.webSocket.multiplex(function () { return ({
	            msg: "sub",
	            id: id,
	            name: streamName,
	            params: [streamParam, addEvent]
	        }); }, function () { return ({
	            msg: "unsub",
	            id: id
	        }); }, function (message) {
	            return typeof message.collection === "string" &&
	                message.collection === streamName &&
	                message.fields.eventName === streamParam;
	        } // Proper Filtering to be done. This is temporary filter just for the stream-room-messages subscription
	        );
	        return subscription;
	    };
	    return RealTimeAPI;
	}());
	RealTimeAPI$2.RealTimeAPI = RealTimeAPI$1;

	Object.defineProperty(lib, "__esModule", { value: true });
	var RealTimeAPI_1 = RealTimeAPI$2;
	var RealTimeAPI = lib.RealTimeAPI = RealTimeAPI_1.RealTimeAPI;

	return RealTimeAPI;

}));
//# sourceMappingURL=rc-realtime-api.js.map
