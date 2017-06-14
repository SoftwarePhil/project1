defmodule RentMe.Time.Event do
    use Timex

    #event id structure? store these in the user?
    defstruct [:id, :start, :end]

    def new(id, delta) do
        now = Timex.now()
        end_time = Timex.shift(now, hours: delta)
        %__MODULE__{id: id, start: now, end: end_time}
    end

    @doc"""
        this function returns the time that has passed
        in miuntes between the end of an event and
        the current time in miunutes.  If the amount
        of time that has passed is negative the event
        is within the time frame defined.  If the number
        returned is postive the event has run over.
    """
    def time_pased(event = %__MODULE__{}) do
       Timex.diff(Timex.now, event.end, :minutes) 
    end

    #weird off set thing in 3rd postion of from_iso8601, not sure if it matters??
    def to_struct(%{"id"=>id, "start"=>start, "end"=>end_time}) do
        {_, s, _} = DateTime.from_iso8601(start)
        {_, e, _} = DateTime.from_iso8601(end_time)
        %__MODULE__{id: id, start: s, end: e}
    end
end