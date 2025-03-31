#### How do I ensure my resources aren't affected?

To avoid service disruptions, each remote endpoint (including dependent requests) your resource interacts with needs to support at least one combination of the same Protocol Version, Cipher Suite, and Elliptical Curve mentioned earlier. If the remote endpoint doesn't support the needed TLS configuration, it needs to be updated with support for some combination of the above-mentioned post-deprecation TLS configuration.

#### After May 1, 2025, what is the behavior for affected resources?

Affected Application Insights resources stop ingesting data and can't access required application components. As a result, some features stop working.

#### Which components does the deprecation affect?

The TLS deprecation detailed in this document should only affect the behavior after May 1, 2025. For more information about CRUD operations, see [Azure Resource Manager TLS Support](/azure/azure-resource-manager/management/tls-support). This resource provides more details on TLS support and deprecation timelines.

#### Where can I get TLS support?

For any general questions around the legacy TLS problem, see [Solving TLS problems](/security/engineering/solving-tls1-problem).