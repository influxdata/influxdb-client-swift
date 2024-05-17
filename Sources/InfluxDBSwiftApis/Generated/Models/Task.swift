//
// Task.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation

public struct Task: Codable {

    public enum LastRunStatus: String, Codable, CaseIterable {
        case failed = "failed"
        case success = "success"
        case canceled = "canceled"
    }
    public var id: String
    /** Type of the task, useful for filtering a task list. */
    public var type: String?
    /** ID of the organization that owns the task. */
    public var orgID: String
    /** Name of the organization that owns the task. */
    public var org: String?
    /** Name of the task. */
    public var name: String
    /** ID of the user who owns this Task. */
    public var ownerID: String?
    /** Description of the task. */
    public var description: String?
    public var status: TaskStatusType?
    public var labels: [Label]?
    /** ID of the authorization used when the task communicates with the query engine. */
    public var authorizationID: String?
    /** Flux script to run for this task. */
    public var flux: String
    /** Interval at which the task runs. &#x60;every&#x60; also determines when the task first runs, depending on the specified time. Value is a [duration literal](https://docs.influxdata.com/flux/v0.x/spec/lexical-elements/#duration-literals)). */
    public var every: String?
    /** [Cron expression](https://en.wikipedia.org/wiki/Cron#Overview) that defines the schedule on which the task runs. Cron scheduling is based on system time. Value is a [Cron expression](https://en.wikipedia.org/wiki/Cron#Overview). */
    public var cron: String?
    /** [Duration](https://docs.influxdata.com/flux/v0.x/spec/lexical-elements/#duration-literals) to delay execution of the task after the scheduled time has elapsed. &#x60;0&#x60; removes the offset. The value is a [duration literal](https://docs.influxdata.com/flux/v0.x/spec/lexical-elements/#duration-literals). */
    public var offset: String?
    /** Timestamp of the latest scheduled and completed run. Value is a timestamp in [RFC3339 date/time format](https://docs.influxdata.com/flux/v0.x/data-types/basic/time/#time-syntax). */
    public var latestCompleted: Date?
    public var lastRunStatus: LastRunStatus?
    public var lastRunError: String?
    public var createdAt: Date?
    public var updatedAt: Date?
    public var links: TaskLinks?

    public init(id: String, type: String? = nil, orgID: String, org: String? = nil, name: String, ownerID: String? = nil, description: String? = nil, status: TaskStatusType? = nil, labels: [Label]? = nil, authorizationID: String? = nil, flux: String, every: String? = nil, cron: String? = nil, offset: String? = nil, latestCompleted: Date? = nil, lastRunStatus: LastRunStatus? = nil, lastRunError: String? = nil, createdAt: Date? = nil, updatedAt: Date? = nil, links: TaskLinks? = nil) {
        self.id = id
        self.type = type
        self.orgID = orgID
        self.org = org
        self.name = name
        self.ownerID = ownerID
        self.description = description
        self.status = status
        self.labels = labels
        self.authorizationID = authorizationID
        self.flux = flux
        self.every = every
        self.cron = cron
        self.offset = offset
        self.latestCompleted = latestCompleted
        self.lastRunStatus = lastRunStatus
        self.lastRunError = lastRunError
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.links = links
    }

}