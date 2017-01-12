# fluent-plugin-filter-base64-decode

[![Build Status](https://travis-ci.org/MerlinDMC/fluent-plugin-filter-base64-decode.svg?branch=master)](https://travis-ci.org/MerlinDMC/fluent-plugin-filter-base64-decode)
[![Gem Version](https://badge.fury.io/rb/fluent-plugin-filter-base64-decode.svg)](http://badge.fury.io/rb/fluent-plugin-filter-base64-decode)

## Overview

A base64 decode filter for [Fluentd](http://www.fluentd.org/).

### Configuration

Decode base64 encoded fields

```
<source>
  @type dummy
  tag example
  dummy {"message": "SGVsbG8gV29ybGQhCg=="}
</source>

<filter example>
  @type base64_decode
  fields message
</filter>

<match **>
  @type stdout
</match>
```
