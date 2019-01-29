# coding: utf-8

class GoohubCLI < Clian::Cli
  desc "test NAME", "Test command, NAME mean outlet name"

  def test(name)
    outlet = Goohub::Outlet.new(name)
    p outlet
  end

end# class GoohubCLI
