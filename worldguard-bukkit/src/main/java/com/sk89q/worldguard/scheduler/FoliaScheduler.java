package com.sk89q.worldguard.scheduler;

import io.papermc.paper.threadedregions.scheduler.*;

import java.util.concurrent.CopyOnWriteArrayList;

public class FoliaScheduler {

    public static CopyOnWriteArrayList<ScheduledTask> scheduledTasks = new CopyOnWriteArrayList<>();
}
